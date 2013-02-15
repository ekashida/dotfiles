#!/bin/bash

WORKING_DIR=$(pwd)
VIM_DIR=$HOME/.vim
VIM_BUNDLE_DIR=$VIM_DIR/bundle

ln -sfv $WORKING_DIR/vimrc          ~/.vimrc
ln -sfv $WORKING_DIR/screenrc       ~/.screenrc
ln -sfv $WORKING_DIR/bashrc         ~/.bashrc           # non-login shells
ln -sfv $WORKING_DIR/bashrc         ~/.bash_profile     # login shell
ln -sfv $WORKING_DIR/inputrc        ~/.inputrc

mkdir -p ~/.ssh
ln -sfv $WORKING_DIR/ssh_config     ~/.ssh/config

if [ -x $(which git) ]; then
    rm -rf $VIM_DIR
    mkdir -p $VIM_BUNDLE_DIR
    pushd $VIM_BUNDLE_DIR
    git clone git@github.com:tpope/vim-pathogen.git
    git clone git@github.com:scrooloose/nerdtree.git
    git clone git@github.com:hallettj/jslint.vim.git
    git clone git@github.com:tristen/vim-sparkup.git
    git clone git@github.com:vim-scripts/mru.vim.git
    popd
fi

# init shell config
source ~/.bashrc
