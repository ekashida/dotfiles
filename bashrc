
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

# n: no swap file used
# p: gives each file its own tab
alias vim='vim -np'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias w='w|sort'
alias ls='ls -G'

# edit/source these config files in one command
alias bashrc='$EDITOR ~/.bashrc; source ~/.bashrc'
alias $LOCALRC='$EDITOR ~/.$LOCALRC; source ~/.$LOCALRC'   # local configs



### MISCELLANEOUS ###

# source local settings
[[ -e ~/.$LOCALRC ]] && source ~/.$LOCALRC

# vim bindings for bash
set -o vi



### Y! SPECIFIC SETTINGS ###

if [ -e /home/y/ ] || [ "$(hostname)" == 'scenegate-lm' ]; then
    export PATH=/home/y/bin:/usr/local/bin:${PATH}
    export SVNROOT=svn+ssh://svn.corp.yahoo.com/

    alias clothnerve='ssh clothnerve.corp.yahoo.com'
    alias clothnerve-vm0='ssh clothnerve-vm0.corp.yahoo.com'
    alias clothnerve-vm1='ssh clothnerve-vm1.corp.yahoo.com'
    alias clothnerve-vm2='ssh clothnerve-vm2.corp.yahoo.com'

    alias cdhtdocs='cd /home/y/share/htdocs/'
    alias errorlog='tail -f /home/y/logs/yapache/error'

    # devel 202 => ssh devel2-02.dev.nacs.corp.sp2
    function devel () {
        host=$(echo "$1" | sed 's/\([0-9]\)\([0-9]\{2\}\)/devel\1-\2.dev.nacs.corp.sp2.yahoo.com/')
        ssh $host
    }

    function create_link_package {
        yinst create -t link $1 -i --clean && rm -rf *tgz
    }
fi
