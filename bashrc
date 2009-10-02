# defining colors for custom prompt.
blue='\e[0;34m'
green='\e[0;32m'
white='\e[0m'

export PS1="\[${blue}\]\t \[${green}\]\h\[${white}\]:\[${blue}\]\W \[${white}\]\$ "

export HISTSIZE=1000
export EDITOR=vim

# vim bindings in bash
set -o vi

# & supresses duplicate entries
export HISTIGNORE="&:ls:[bf]g:history:exit"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias w='w|sort'
alias ls='ls -G'

alias bashrc='$EDITOR ~/.bashrc; source ~/.bashrc'

# y! specific settings
[[ $YROOT_NAME ]] && export PS1="\[${blue}\]\t \[${green}\]${YROOT_NAME}\[${white}\]:\[${blue}\]\W \[${white}\]\$ "
[[ $HOSTNAME =~ 'yahoo.com$' ]] && export PATH=/home/y/bin:${PATH}
