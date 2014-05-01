#!/bin/bash -x

WORKING_DIR=$(pwd)
INSTALL_DIR=/usr/local/bin
VIM_DIR=$HOME/.vim
VIM_BUNDLE_DIR=$VIM_DIR/bundle
SNIPPETS_DIR=$VIM_BUNDLE_DIR/snipmate.vim/snippets

ln -sfv $WORKING_DIR/vimrc          ~/.vimrc
ln -sfv $WORKING_DIR/screenrc       ~/.screenrc
ln -sfv $WORKING_DIR/bashrc         ~/.bashrc           # non-login shells
ln -sfv $WORKING_DIR/bashrc         ~/.bash_profile     # login shell
ln -sfv $WORKING_DIR/inputrc        ~/.inputrc
ln -sfv $WORKING_DIR/jshintrc       ~/.jshintrc
ln -sfv $WORKING_DIR/gitconfig      ~/.gitconfig

ln -sfv $WORKING_DIR/socksproxy     $INSTALL_DIR/socksproxy

mkdir -p ~/.ssh
ln -sfv $WORKING_DIR/ssh_config     ~/.ssh/config

if [ -x $(which git) ]; then
    mkdir -p $VIM_BUNDLE_DIR
    pushd $VIM_BUNDLE_DIR
    [ ! -e vim-pathogen ] && git clone git@github.com:tpope/vim-pathogen.git
    [ ! -e nerdtree     ] && git clone git@github.com:scrooloose/nerdtree.git
    [ ! -e jshint.vim   ] && git clone git@github.com:wookiehangover/jshint.vim.git
    [ ! -e vim-sparkup  ] && git clone git@github.com:tristen/vim-sparkup.git
    [ ! -e mru.vim      ] && git clone git@github.com:vim-scripts/mru.vim.git
    [ ! -e vim-fugitive ] && git clone git@github.com:tpope/vim-fugitive.git
    [ ! -e snipmate.vim ] && git clone git@github.com:msanders/snipmate.vim.git
    popd
fi

if [ -e $SNIPPETS_DIR ]; then
    ln -sfv $WORKING_DIR/snippets/* $SNIPPETS_DIR
fi

# init shell config
source ~/.bashrc
