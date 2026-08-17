#!/usr/bin/env python3
"""Two-stage Rofi wallpaper picker (HyDE-style filmstrip).

Stage 1: horizontal filmstrip of wallpaper thumbnails (full-width band).
Stage 2: matugen seed-color chooser (compact card, chips + hex).
Apply:   matugen image <wall> -m dark --source-color-index N
         + awww img --transition-type center <wall>   (in parallel)

Deps: rofi (wayland), matugen, awww, python-pillow, util-linux (script).
"""
import hashlib
import os
import re
import select
import signal
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

# ------------------------------- config -----------------------------------
WALL_DIRS  = [Path(os.environ.get("WALLPAPER_DIR", f"{Path.home()}/Pictures/Wallpapers"))]
EXTS       = {".png", ".jpg", ".jpeg", ".jfif", ".webp", ".bmp"}
MODE       = "dark"          # matugen -m
TRANSITION = "center"        # awww --transition-type
THUMB_SIZE = (300, 430)      # portrait canvas, like HyDE
THUMB_RAD  = 28
CACHE      = Path(os.environ.get("XDG_CACHE_HOME", f"{Path.home()}/.cache")) / "rofi-wallpaper"
SCRIPT     = Path(__file__).resolve()
THEME      = f"{Path.home()}/.config/rofi/themes/wallpaper.rasi"
SEED_THEME = f"{Path.home()}/.config/rofi/themes/wallpaper-seeds.rasi"
STATE_DIR  = Path(os.environ.get("XDG_STATE_HOME", f"{Path.home()}/.local/state")) / "rofi-wallpaper"
# ---------------------------------------------------------------------------
THUMBS, SWATCHES = CACHE / "thumbs", CACHE / "swatches"
HEX_RE = re.compile(r"#[0-9a-fA-F]{6}\b")
DN = subprocess.DEVNULL


def dedupe(seq):
    seen, out = set(), []
    for x in seq:
        x = x.lower()
        if x not in seen:
            seen.add(x), out.append(x)
    return out


def log(msg):
    try:
        CACHE.mkdir(parents=True, exist_ok=True)
        (CACHE / "wallpaper.log").open("a").write(f"{time.strftime('%T')} {msg}\n")
    except Exception:
        pass


def thumbnail(w: Path) -> Path:
    THUMBS.mkdir(parents=True, exist_ok=True)
    st = w.stat()
    key = hashlib.md5(f"{w}|{st.st_size}|{int(st.st_mtime)}".encode()).hexdigest()
    out = THUMBS / f"{key}.png"
    if not out.exists():
        from PIL import Image, ImageDraw
        tmp = out.with_suffix(".tmp")
        with Image.open(w) as im:
            im = im.convert("RGBA")
            tw, th = THUMB_SIZE
            ar = tw / th
            iw, ih = im.size
            if iw / ih > ar:                       # wider than canvas: crop sides
                nw = int(ih * ar)
                l = (iw - nw) // 2
                im = im.crop((l, 0, l + nw, ih))
            else:                                  # taller: crop top/bottom
                nh = int(iw / ar)
                t = (ih - nh) // 2
                im = im.crop((0, t, iw, t + nh))
            im = im.resize(THUMB_SIZE, Image.LANCZOS)
            mask = Image.new("L", THUMB_SIZE, 0)   # bake rounded corners into alpha
            ImageDraw.Draw(mask).rounded_rectangle([0, 0, tw - 1, th - 1],
                                                   radius=THUMB_RAD, fill=255)
            im.putalpha(mask)
            im.save(tmp, "PNG")
        tmp.rename(out)
    return out


def swatch(hexc: str) -> Path:
    SWATCHES.mkdir(parents=True, exist_ok=True)
    out = SWATCHES / f"{hexc.lstrip('#')}.png"
    if not out.exists():
        from PIL import Image, ImageDraw
        im = Image.new("RGBA", (64, 64), hexc + "ff")
        m = Image.new("L", (64, 64), 0)
        ImageDraw.Draw(m).rounded_rectangle([0, 0, 63, 63], radius=16, fill=255)
        im.putalpha(m)
        im.save(out, "PNG")
    return out


def capture_picker(wall: Path):
    """Scrape matugen's interactive picker through a pseudo-TTY (old matugen)."""
    cmd = f"matugen image '{wall}' -m {MODE}"
    try:
        p = subprocess.Popen(["script", "-qec", cmd, "/dev/null"],
                             stdout=subprocess.PIPE, stderr=DN, start_new_session=True)
    except Exception:
        return []
    out, last, start = "", None, time.time()
    try:
        while time.time() - start < 10:
            r, _, _ = select.select([p.stdout], [], [], 0.1)
            if r:
                chunk = os.read(p.stdout.fileno(), 65536).decode("utf-8", "ignore")
                if not chunk:
                    break
                out += chunk
                if HEX_RE.search(chunk):
                    last = time.time()
            else:
                if last and time.time() - last > 0.8:   # picker idle -> list complete
                    break
                if p.poll() is not None:
                    break
    finally:
        try:
            os.killpg(p.pid, signal.SIGTERM)
        except Exception:
            pass
    return dedupe(HEX_RE.findall(out))


def pil_colors(wall: Path):
    """Last-resort dominant colors (order won't match matugen's picker)."""
    try:
        from PIL import Image
        with Image.open(wall) as im:
            im = im.convert("RGB"); im.thumbnail((160, 160))
            q = im.quantize(colors=5, method=Image.Quantize.MEDIANCUT)
            pal = q.getpalette()
            return [f"#{pal[i*3]:02x}{pal[i*3+1]:02x}{pal[i*3+2]:02x}"
                    for _, i in sorted(q.getcolors() or [], key=lambda c: -c[0])]
    except Exception:
        return []


def get_seed_colors(wall: Path):
    """Return (colors, mode). mode='index' -> --source-color-index, 'hex' -> color mode."""
    # 1) headless flag (matugen with PR #298 merged)
    try:
        r = subprocess.run(["matugen", "image", str(wall), "-m", MODE, "--show-source-colors"],
                           capture_output=True, text=True, timeout=30)
        if r.returncode == 0:
            hexes = dedupe(HEX_RE.findall(r.stdout))
            if hexes:
                return hexes, "index"
    except Exception:
        pass
    # 2) TTY capture of the interactive picker (exact order => indices valid)
    hexes = capture_picker(wall)
    if hexes:
        return hexes, "index"
    # 3) Pillow fallback (indices unknown => use `matugen color hex`)
    return pil_colors(wall), "hex"


def list_wallpapers():
    walls = []                                     # (root_dir, path), recursive
    seen = set()
    for d in WALL_DIRS:
        if d.is_dir():
            for p in d.rglob("*"):
                if p.is_file() and p.suffix.lower() in EXTS and p not in seen:
                    seen.add(p)
                    walls.append((d, p))
    walls.sort(key=lambda t: str(t[1]).lower())
    with ThreadPoolExecutor(8) as ex:              # pre-bake thumbnails in parallel
        list(ex.map(lambda t: thumbnail(t[1]), walls))
    for d, w in walls:
        label = w.name if w.parent == d else str(w.relative_to(d))
        sys.stdout.write(label + f"\0icon\x1f{thumbnail(w)}\x1finfo\x1f{w}\n")


def on_wallpaper_picked():
    wall = os.environ.get("ROFI_INFO", "")
    if not wall or not Path(wall).exists():
        name = sys.argv[1]
        wall = ""
        for d in WALL_DIRS:                        # fallback: resolve by filename
            for p in d.rglob(name):
                if p.is_file():
                    wall = str(p)
                    break
            if wall:
                break
    if not wall:
        return
    # detached so stage-1 rofi can exit; the runner opens the seed chooser
    subprocess.Popen([sys.executable, str(SCRIPT), "__seed_runner__", wall],
                     start_new_session=True, stdin=DN, stdout=DN, stderr=DN)


def list_seeds():
    for i, hexc in enumerate(os.environ.get("WP_SEEDS", "").split(",")):
        if hexc:
            sys.stdout.write(f"{hexc}\0icon\x1f{swatch(hexc)}\x1finfo\x1f{i}\n")


def on_seed_picked():
    wall = os.environ.get("WP_WALL", "")
    if not wall:
        return
    subprocess.Popen([sys.executable, str(SCRIPT), "__apply__", wall,
                      os.environ.get("ROFI_INFO", "0"),
                      os.environ.get("WP_SEED_MODE", "index"), sys.argv[1]],
                     start_new_session=True, stdin=DN, stdout=DN, stderr=DN)


def apply(wall, idx, mode, hexc):
    """Run matugen and awww at the same time; remember the choice."""
    log(f"apply wall={wall} idx={idx} mode={mode} hex={hexc}")
    try:  # remember last choice so login can restore it
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        (STATE_DIR / "last-wallpaper").write_text(wall)
    except Exception:
        pass
    if mode == "index":
        m = ["matugen", "image", wall, "-m", MODE, "--source-color-index", idx]
    else:
        m = ["matugen", "color", "hex", hexc, "-m", MODE]
    p1 = subprocess.Popen(m)                                                # matugen
    p2 = subprocess.Popen(["awww", "img", "--transition-type", TRANSITION, wall])  # in parallel
    p1.wait()
    p2.wait()
    log("apply done")


def main():
    args = sys.argv[1:]

    if args and args[0] == "--rofi":                     # entry point (Hyprland bind)
        os.execvp("rofi", ["rofi", "-show", "wallpaper",
                           "-modi", f"wallpaper:{SCRIPT}", "-theme", THEME])

    if args and args[0] == "--debug-seeds":              # terminal test of extraction
        seeds, mode = get_seed_colors(Path(args[1]).expanduser())
        print(f"mode={mode}")
        for s in seeds:
            print(s)
        sys.exit(0)

    if args and args[0] == "__seed_runner__":            # between the two rofi stages
        time.sleep(0.35)                                 # let stage-1 rofi close
        wall = Path(args[1])
        seeds, mode = get_seed_colors(wall)
        if not seeds:
            log(f"no seed colors for {wall}")
            sys.exit(1)
        env = dict(os.environ, WP_STAGE="seeds", WP_WALL=str(wall),
                   WP_SEEDS=",".join(seeds), WP_SEED_MODE=mode)
        subprocess.run(["rofi", "-show", "seed", "-modi", f"seed:{SCRIPT}",
                        "-theme", SEED_THEME, "-p", wall.name], env=env)
        sys.exit(0)

    if args and args[0] == "__apply__":
        apply(*args[1:5])
        sys.exit(0)

    # ---- called by rofi itself ----
    picked = args[0] if args else None
    if os.environ.get("WP_STAGE") == "seeds":
        list_seeds() if picked is None else on_seed_picked()
    else:
        list_wallpapers() if picked is None else on_wallpaper_picked()


if __name__ == "__main__":
    main()
