alias cp 'cp -i'
alias mv 'mv -i'
alias rm 'rm -i'

alias ll 'ls -l'
alias ls 'ls -G'

alias vim nvim

alias git-local-branch-clean 'git branch --merged | grep -v master | xargs -n 1 git branch -d'
alias git-remote-branch-clean "git branch -r --merged | grep -v master | sed 's/origin\//:/' | xargs -n 1 git push origin"
