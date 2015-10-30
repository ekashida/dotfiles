function fish_mode_prompt
  # Overriding this function to disable indicator for vi mode
end

fish_vi_mode

set --export EDITOR vim

alias cp 'cp -i'
alias ll 'ls -l'
alias ls 'ls -G'
alias mv 'mv -i'
alias rm 'rm -i'

alias git-local-branch-clean 'git branch --merged | grep -v master | xargs -n 1 git branch -d'
alias git-remote-branch-clean "git branch -r --merged | grep -v master | sed 's/origin\//:/' | xargs -n 1 git push origin"
