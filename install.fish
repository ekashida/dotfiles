#!/usr/bin/env fish

set working_dir (pwd)
set config_dir ~/.config
set fish_config_dir "$config_dir/fish"

mkdir -p $fish_config_dir

ln -Fsv "$working_dir/fish/config.fish"   "$fish_config_dir/config.fish"
ln -Fsv "$working_dir/fish/functions"     "$fish_config_dir"
ln -Fsv "$working_dir/screenrc"           "$HOME/.screenrc"
ln -Fsv "$working_dir/gitconfig"          "$HOME/.gitconfig"
ln -Fsv "$working_dir/vimrc"              "$HOME/.vimrc"

install_from_github
