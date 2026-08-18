export EDITOR=nvim
export VISUAL=nvim

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Disable Oh My Zsh built-in themes (we are using Starship instead)
ZSH_THEME=""

# Plugins to load (custom ones are in ~/.oh-my-zsh/custom/plugins/)
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

# Load Oh My Zsh core and plugins
source $ZSH/oh-my-zsh.sh


# ==========================================
# 🚀 RUN FASTFETCH ON TERMINAL STARTUP
# ==========================================
# Only run if the shell is interactive (prevents issues with scripts/background tasks)
#if [[ -o interactive ]]; then
#    clear        # Wipes the screen so the logo prints cleanly at the top
#    fastfetch    # Runs your custom config
#fi

# Initialize Starship prompt (must be at the very bottom)
eval "$(starship init zsh)"
