# Source git completion
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
	. /usr/share/git-core/contrib/completion/git-prompt.sh
fi

PS1='\[\033[01;31m\]\t \[\033[1;33;1;32m\]\u: \[\033[1;33m\]\w \[\033[1;37m\]$(__git_ps1 "[%s]")\[\033[0m\]$ '
ulimit -c unlimited

export VISUAL=vim
export EDITOR="$VISUAL"

# git aliases
alias gits='git status'
alias gitd='git diff'
alias gitl='git log'
alias gitb='git branch'
alias gitf="git diff-tree --no-commit-id --name-only -r"
alias gitg="git grep -n"


# colors
export PAGER=less
export LESS_TERMCAP_mb=$'\E[01;33m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;42;30m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'

export GREP_COLOR="1;31"

# colorised output
alias ping="grc ping"
alias traceroute="grc traceroute"
alias netstat="grc netstat"

# some more ls aliases
alias ll='ls -lFha --color'
alias l='ls -CFl --color'
alias la='ls -A --color'

# other aliases
alias q="cd .."
alias g='vim -g'

alias cs='cscope -q -R -b'
gr () { grep -rnI --color "$1" "${2:-.}"; }
gri () { grep -rnIi --color "$1" "${2:-.}"; }

# start tor browser
#tor_start() { cd /opt/tor-browser_en-US && ./start-tor-browser.desktop; }
