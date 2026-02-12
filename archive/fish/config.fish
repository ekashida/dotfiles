begin
  function fish_mode_prompt
    # Overriding this function to disable indicator for vi mode
  end

  fish_vi_key_bindings

  set --export EDITOR vim
end

source ~/.config/fish/alias.fish

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
