
### ENVIRONMENT VARIABLES ###

LOCALRC='localrc'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
WHITE='\e[0m'



### EXPORTED ENVIRONMENT VARIABLES ###

export PS1="\[${BLUE}\]\t \[${GREEN}\]\h\[${WHITE}\]:\[${BLUE}\]\W \[${WHITE}\]\$ "
export HISTIGNORE="&:ls:[bf]g:history:exit" # & supresses duplicate entries
export HISTSIZE=1000
export EDITOR=vim
export PATH=~/local/bin:$PATH



### ALIASES ###

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias w='w|sort'
alias ls='ls -G'
alias ll='ls -l'

# edit/source these config files in one command
alias bashrc='$EDITOR ~/.bashrc; source ~/.bashrc'
alias $LOCALRC='$EDITOR ~/.$LOCALRC; source ~/.$LOCALRC'   # local configs



### MISCELLANEOUS ###

# source local settings
[[ -e ~/.$LOCALRC ]] && source ~/.$LOCALRC

# vim bindings for bash
set -o vi



### Y! SPECIFIC SETTINGS ###

if [ $USER == 'keugene' ]; then
    export PATH=/home/y/bin:/usr/local/bin:${PATH}
    export SVNROOT=svn+ssh://svn.corp.yahoo.com/

    [[ $YROOT_NAME ]] && export PS1="\[${blue}\]\t \[${green}\]${YROOT_NAME}@\h\[${white}\]:\[${blue}\]\W \[${white}\]\$ "

    alias clothnerve='ssh clothnerve.corp.yahoo.com'
    alias clothnerve-vm0='ssh clothnerve-vm0.corp.yahoo.com'
    alias clothnerve-vm1='ssh clothnerve-vm1.corp.yahoo.com'
    alias clothnerve-vm2='ssh clothnerve-vm2.corp.yahoo.com'

    [ -e /home/y/ ] && alias cdhtdocs='cd /home/y/share/htdocs/'
    [ -e /home/y/ ] && alias errorlog='tail -f /home/y/logs/yapache/error'

    function create_link_package {
        yinst create -t link $1 -i --clean && rm -rf *tgz
    }
fi
