# Custom prompt.
blue='\e[0;34m'
green='\e[0;32m'
white='\e[0m'

export PS1="\[${blue}\]\t \[${green}\]\h\[${white}\]:\[${blue}\]\W \[${white}\]\$ "
test $YROOT_NAME && export PS1="\[${blue}\]\t \[${green}\]${YROOT_NAME}\[${white}\]:\[${blue}\]\W \[${white}\]\$ "

# Vim bindings in bash.
set -o vi

# Local alias file.
source ~/.aliases
alias realias='$EDITOR ~/.aliases; source ~/.aliases'

# & supresses duplicate entries
# [ \t] doesn't record any commands with preceding whitespace.
export HISTIGNORE="&:[ \t]*:ls:[bf]g:history:exit"

export HISTSIZE=1000
export EDITOR=vim
