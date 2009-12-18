
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



### ALIASES ###

# n: no swap file used
# p: gives each file its own tab
alias vim='vim -np'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias w='w|sort'
alias ls='ls --color'

alias bashrc='$EDITOR ~/.bashrc; source ~/.bashrc'
alias $LOCALRC='$EDITOR ~/.$LOCALRC; source ~/.bashrc'



### MISCELLANEOUS ###

# source local settings
[[ -e ~/.$LOCALRC ]] && source ~/.$LOCALRC

# vim bindings for bash
set -o vi



### Y! SPECIFIC SETTINGS ###

[[ $YROOT_NAME ]] && export PS1="\[${blue}\]\t \[${green}\]${YROOT_NAME}\[${white}\]:\[${blue}\]\W \[${white}\]\$ "

if [[ $USER = keugene ]]; then
    export PATH=/home/y/bin:${PATH}
    export CVSROOT=:ext:${USER}@vault.yahoo.com:/CVSROOT
    export CVS_RSH=yssh
    export SVNROOT=svn+ssh://svn.corp.yahoo.com/

    alias clothnerve='ssh clothnerve.corp.yahoo.com'
    alias clothnerve-vm0='ssh clothnerve-vm0.corp.yahoo.com'
    alias clothnerve-vm1='ssh clothnerve-vm1.corp.yahoo.com'
    alias clothnerve-vm2='ssh clothnerve-vm2.corp.yahoo.com'
    alias isrv4-vm2='ssh isrv4-vm2.eglbp.corp.yahoo.com'
    alias esb-frontend2='ssh esb-frontend2.ep.staging.re1.yahoo.com'
    alias eah1-qa-nacs='ssh eah1.qa.nacs.yahoo.com'

    alias cdhtdocs='cd /home/y/share/htdocs/'
    alias errorlog='tail -f /home/y/logs/yapache/error'
    alias which_yroot_yapache='sudo lsof | grep yapache | grep cwd'
fi
