# defining colors for custom prompt.
blue='\e[0;34m'
green='\e[0;32m'
white='\e[0m'

export PS1="\[${blue}\]\t \[${green}\]\h\[${white}\]:\[${blue}\]\W \[${white}\]\$ "

export HISTSIZE=1000
export EDITOR=vim

# vim bindings in bash
set -o vi

# n: no swap file used
# p: gives each file its own tab
alias vim='vim -np'

# & supresses duplicate entries
export HISTIGNORE="&:ls:[bf]g:history:exit"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias w='w|sort'
alias ls='ls --color'

alias bashrc='$EDITOR ~/.bashrc; source ~/.bashrc'

### begin y! specific settings ###
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
    alias plague='ssh clothnerve.corp.yahoo.com -p 5522'
    alias dev-stp-001='ssh dev-stp-001.ysm.corp.sp1.yahoo.com'
    alias isrv4-vm2='ssh isrv4-vm2.eglbp.corp.yahoo.com'

    alias cdhtdocs='cd /home/y/share/htdocs/'
    alias which_yroot_yapache='sudo lsof | grep yapache | grep cwd'
fi
### end y! specific settings ###

[[ -e ~/.local_settings ]] && source ~/.local_settings # local settings
