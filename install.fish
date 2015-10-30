#!/usr/bin/env fish

begin
  set -l working_dir (pwd)
  set -l config_dir ~/.config/fish

  mkdir -p $config_dir

  set -l source_config (printf '%s/fish/config.fish' $working_dir)
  set -l target_config (printf '%s/config.fish' $config_dir)
  if not test -L $target_config
    ln -sfv $source_config $target_config
  end

  set -l source_function_dir (printf '%s/fish/functions' $working_dir)
  set -l target_function_dir (printf '%s/functions' $config_dir)
  # Quick check, since the force option doesn't seem to be working for ln
  if not test -L $target_function_dir
    ln -sv $source_function_dir $target_function_dir
  end
end
