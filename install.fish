#!/usr/bin/env fish

set working_dir (pwd)
set config_dir ~/.config
set fish_config_dir "$config_dir/fish"
set nvim_config_dir "$config_dir/nvim"
set nvim_plugin_plug "$nvim_config_dir/autoload/plug.vim"

mkdir -p $fish_config_dir
mkdir -p $nvim_config_dir

ln -Fsv "$working_dir/fish/alias.fish"    "$fish_config_dir/alias.fish"
ln -Fsv "$working_dir/fish/config.fish"   "$fish_config_dir/config.fish"
ln -Fsv "$working_dir/fish/functions"     "$fish_config_dir"
ln -Fsv "$working_dir/nvim/init.vim"      "$nvim_config_dir/init.vim"
ln -Fsv "$working_dir/screenrc"           "$HOME/.screenrc"
ln -Fsv "$working_dir/gitconfig"          "$HOME/.gitconfig"

install_from_github

if not test -L $nvim_plugin_plug
  echo "Installing vim-plug to $nvim_plugin_plug"
  curl -fLo $nvim_plugin_plug --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
end
