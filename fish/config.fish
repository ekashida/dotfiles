function fish_mode_prompt
  # Overriding this function to disable indicator for vi mode
end

fish_vi_mode

set --export EDITOR vim

alias cp='cp -i'
alias ll='ls -l'
alias ls='ls -G'
alias mv='mv -i'
alias rm='rm -i'
