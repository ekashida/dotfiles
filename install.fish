#!/usr/bin/env fish

begin
  set -l working_dir (pwd)
  set -l config_dir ~/.config/fish

  mkdir -p $config_dir

  set -l source (printf '%s/fish/config.fish' $working_dir)
  set -l target (printf '%s/config.fish' $config_dir)
  if not test -L $target
    ln -sv $source $target
  end

  set -l source (printf '%s/fish/functions' $working_dir)
  set -l target (printf '%s/functions' $config_dir)
  if not test -L $target
    ln -sv $source $target
  end
end
