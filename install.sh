#!/bin/bash

WORKING_DIR=$(pwd)

ln -sfv $WORKING_DIR/screenrc       ~/.screenrc
ln -sfv $WORKING_DIR/bashrc         ~/.bashrc           # non-login shells
ln -sfv $WORKING_DIR/bashrc         ~/.bash_profile     # login shell
ln -sfv $WORKING_DIR/inputrc        ~/.inputrc

mkdir -p ~/.ssh
ln -sfv $WORKING_DIR/ssh_config     ~/.ssh/config

# if `~/.vim/` already exists, the subsequent `ln` command ends up creating a
# symlink to `vim/` inside `~/.vim/` instead of the `~/.vim/` symlink itself
if [ -e ~/.vim ]; then
    rm -rf ~/.vim
fi
ln -sfv $WORKING_DIR/vim/           ~/.vim
ln -sfv $WORKING_DIR/vimrc          ~/.vimrc

# init shell config
source ~/.bashrc
