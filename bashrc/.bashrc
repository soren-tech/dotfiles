#
# ~/.bashrc
#
# ~/.bashrc

# Export variables FIRST so they are always available
export EDITOR="nvim"
export VISUAL="nvim"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# ... rest of your config
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR="nvim"
export VISUAL="nvim"
export LIBVIRT_DEFAULT_URI=qemu:///system
