ulimit -c unlimited

export VISUAL=vim
export EDITOR=vim

# git aliases
alias gits='git status'
alias gitd='git diff'
alias gitl='git log'
alias gitb='git branch'
alias gitf="git diff-tree --no-commit-id --name-only -r"
alias gitg="git grep -n"

alias q="cd .."
alias g='vim -g'
alias cs='cscope -q -R -b'
gr () { grep -rnI --color "$1" "${2:-.}"; }
gri () { grep -rnIi --color "$1" "${2:-.}"; }

if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias ll="exa --long --all --group"
    alias l="ll"
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi
