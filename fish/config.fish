begin
  function fish_mode_prompt
    # Overriding this function to disable indicator for vi mode
  end

  fish_vi_key_bindings

  set --export EDITOR vim
end

begin
  alias cp 'cp -i'
  alias ll 'ls -l'
  alias ls 'ls -G'
  alias mv 'mv -i'
  alias rm 'rm -i'

  alias git-local-branch-clean 'git branch --merged | grep -v master | xargs -n 1 git branch -d'
  alias git-remote-branch-clean "git branch -r --merged | grep -v master | sed 's/origin\//:/' | xargs -n 1 git push origin"
end


begin
  set localrc_path ~/.config/fish/config.fish.local

  function source_localrc
    source $localrc_path
  end

  function localrc
    vim $localrc_path
    source_localrc
  end

  source_localrc
end

begin
  set z_fish_path ~/repos/z-fish/z.fish
  if test -e $z_fish_path
    source $z_fish_path
  end
end
