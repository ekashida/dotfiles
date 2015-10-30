#!/bin/bash -x

WORKING_DIR=$(pwd)
INSTALL_DIR=/usr/local/bin
VIM_DIR=$HOME/.vim
VIM_BUNDLE_DIR=$VIM_DIR/bundle
REPOS_DIR=$HOME/repos

ln -sfv $WORKING_DIR/vimrc          ~/.vimrc
ln -sfv $WORKING_DIR/screenrc       ~/.screenrc
ln -sfv $WORKING_DIR/gitconfig      ~/.gitconfig

ln -sfv $WORKING_DIR/socksproxy     $INSTALL_DIR/socksproxy

if [ -x $(which git) ]; then
    mkdir -p $VIM_BUNDLE_DIR
    pushd $VIM_BUNDLE_DIR
    [ ! -e ag.vim           ] && git clone git@github.com:rking/ag.vim.git
    [ ! -e ctrlp.vim        ] && git clone git@github.com:ctrlpvim/ctrlp.vim.git
    [ ! -e editorconfig-vim ] && git clone git@github.com:editorconfig/editorconfig-vim.git
    [ ! -e nerdtree         ] && git clone git@github.com:scrooloose/nerdtree.git
    [ ! -e syntastic        ] && git clone git@github.com:scrooloose/syntastic.git
    [ ! -e vim-fugitive     ] && git clone git@github.com:tpope/vim-fugitive.git
    [ ! -e vim-javascript   ] && git clone git@github.com:pangloss/vim-javascript.git
    [ ! -e vim-pathogen     ] && git clone git@github.com:tpope/vim-pathogen.git
    [ ! -e vim-sparkup      ] && git clone git@github.com:tristen/vim-sparkup.git
    popd

    mkdir -p $REPOS_DIR
    pushd $REPOS_DIR

    # Install for z happens in bashrc
    [ ! -e z ] && git clone git@github.com:rupa/z.git

    [ ! -e n ] && git clone git@github.com:tj/n.git
    pushd n && make install && popd

    popd
fi

if [ -x $(which npm) ]; then
    npm -g install eslint
    npm -g install babel-eslint
    npm -g install eslint-plugin-react
fi
