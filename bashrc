
### ENVIRONMENT VARIABLES ###

LOCALRC='localrc'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
WHITE='\e[0m'

# For selenium testing
FIREFOX=/Applications/Firefox.app/Contents/MacOS



### EXPORTED ENVIRONMENT VARIABLES ###

export PS1="\[${BLUE}\]\t \[${GREEN}\]\h\[${WHITE}\]:\[${BLUE}\]\W \[${WHITE}\]\$ "
export HISTIGNORE="&:ls:[bf]g:history:exit" # & supresses duplicate entries
export HISTSIZE=1000
export EDITOR=vim
export PATH=~/local/bin:${PATH}:${FIREFOX}



### ALIASES ###

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias w='w|sort'
alias ls='ls -G'
alias ll='ls -l'

alias grunt='node_modules/.bin/grunt'

# edit/source these config files in one command
alias bashrc='$EDITOR ~/.bashrc; source ~/.bashrc'
alias $LOCALRC='$EDITOR ~/.$LOCALRC; source ~/.$LOCALRC'   # local configs



### MISCELLANEOUS ###

# source local settings
[[ -e ~/.$LOCALRC ]] && source ~/.$LOCALRC

# vim bindings for bash
set -o vi



### Y! SPECIFIC SETTINGS ###

export SVNROOT=svn+ssh://svn.corp.yahoo.com/

alias samegame='ssh samegame.corp.gq1.yahoo.com'

if [ $HOME != '/Users/keugene' ]; then
    export PATH=/home/y/bin:${PATH}

    if [ -e /usr/local/bin/yssh ]; then
        export SVN_SSH=/usr/local/bin/yssh
    fi

    alias cdhtdocs='cd /home/y/share/htdocs/'
    alias errorlog='tail -f /home/y/logs/yapache/error'

    function create_link_package {
        yinst create -t link $1 -i --clean && rm -rf *tgz
    }
fi
