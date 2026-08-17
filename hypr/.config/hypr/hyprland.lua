-- ~/.config/hypr/hyprland.lua

-- Set programs that you use
local terminal = "kitty"
local fileManager = "kitty -e yazi"
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")

local browser = "google-chrome-stable"
local menu = "rofi -show drun -theme /home/ms/.config/rofi/themes/app-launcher.rasi"

-- Colors
local colors = dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")
local activeBorder = colors.active_border
local inactiveBorder = colors.inactive_border
local shadowCol = colors.shadow
local textColor = colors.text
local mainMod = "SUPER"

-- ENVIRONMENT VARIABLES
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("VDPAU_DRIVER", "va_gl")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("GTK_IM_MODULE", "fcitx")

-- HARDWARE (MONITORS)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- LOOK AND FEEL (CONFIGURATION)
hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:none",
        follow_mouse = 1,
        numlock_by_default = true,
    },
    general = {
        gaps_in = 2,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = activeBorder,
            inactive_border = inactiveBorder,
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = shadowCol,
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})

-- ANIMATIONS (CURVES & LEAVES)
hl.curve("myBezier", { type="bezier", points= { {0.05, 0.9}, {0.1, 1.05} } })
hl.animation({ leaf="windows", enabled=true, speed=5, bezier="myBezier" })
hl.animation({ leaf="windowsOut", enabled=true, speed=5, bezier="default", style="popin 80%" })
hl.animation({ leaf="border", enabled=true, speed=10, bezier="default" })
hl.animation({ leaf="borderangle", enabled=true, speed=8, bezier="default" })
hl.animation({ leaf="fade", enabled=true, speed=5, bezier="default" })
hl.animation({ leaf="workspaces", enabled=true, speed=4, bezier="default" })

-- KEYBINDINGS (BINDS & DISPATCHERS)

-- System & Apps
hl.bind(mainMod .. " + DELETE", hl.dsp.exec_cmd("hyprctl dispatch exit"))

local powerMenuScript = os.getenv("HOME") .. "/.config/rofi/scripts/power-menu.sh"
hl.bind(mainMod .. " + apostrophe", hl.dsp.exec_cmd(powerMenuScript .. " --toggle"))

hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("pkill -x waybar || waybar"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod ..  " + D ", hl.dsp.exec_cmd( "pkill -x rofi || " .. menu))
hl.bind(
    mainMod .. " + V",
    hl.dsp.exec_cmd(
        "pkill -x rofi || cliphist list | rofi -dmenu -p Clipboard -display-columns 2 -theme /home/ms/.config/rofi/themes/clipboard.rasi | cliphist decode | wl-copy"
    )
)
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

-- Wallpaper picker (MainMod + Shift + W)
local wallpaperPicker = "/home/ms/.config/rofi/scripts/wallpaper.py --rofi"
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("pkill -x rofi || " .. wallpaperPicker))

-- Audio Keys (locked=true replaces bindl, repeating=true replaces binde)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked=true, repeating=true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked=true, repeating=true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked=true, repeating=true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked=true, repeating=true })

-- Window Controls
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
-- Quit ALL apps/windows (MainMod + Alt + Shift + Q)
local closeAllScript = os.getenv("HOME") .. "/.config/hypr/scripts/close-all-windows.sh"

hl.bind(
  mainMod .. " + ALT + SHIFT + Q",
  hl.dsp.exec_cmd(closeAllScript)
)

hl.bind(mainMod .. " + T", hl.dsp.window.float({ action="toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction="left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction="right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction="up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction="down" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction="left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction="right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction="up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction="down" }))

-- Move Windows
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction="left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction="right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction="up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction="down" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction="left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction="right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction="up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction="down" }))

-- Mouse Actions (bindm)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse=true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse=true })

-- Workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace=i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace=i }))
end

-- Special Workspaces
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("S-pad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace="special:S-pad" }))
hl.bind(mainMod .. " + N", hl.dsp.workspace.toggle_special("N-pad"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace="special:N-pad" }))
hl.bind(mainMod .. " + A", hl.dsp.workspace.toggle_special("A-pad"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace="special:A-pad" }))

-- Stopwatch
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("~/.config/waybar/stopwatch.sh toggle"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("~/.config/waybar/stopwatch.sh reset"))

-- AUTOSTART (ON HYPRLAND START)
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar &")
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd( os.getenv("HOME") .. "/.config/hypr/scripts/restore-wallpaper.sh" )
    hl.exec_cmd("mako &")
    hl.exec_cmd("nm-applet --indicator &")
    hl.exec_cmd("/usr/lib/hyprpolkitagent &")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sh -c 'wl-clip-persist --clipboard regular >/dev/null 2>&1 &'")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
    hl.exec_cmd("cliphist wipe")
    hl.exec_cmd("udiskie &")
    hl.exec_cmd("fcitx5 -d")

    hl.exec_cmd("obsidian &")
    hl.exec_cmd("anki &")
    hl.exec_cmd("zotero &")
end)
