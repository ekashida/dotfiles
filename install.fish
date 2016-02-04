#!/usr/bin/env fish

begin
  set working_dir (pwd)
  set config_dir ~/.config

  set fish_config_dir "$config_dir/fish"
  mkdir -p $fish_config_dir

  set source "$working_dir/fish/config.fish"
  set target "$fish_config_dir/config.fish"
  if not test -L $target
    ln -sv $source $target
  end

  set source "$working_dir/fish/functions"
  set target "$fish_config_dir/functions"
  if not test -L $target
    ln -sv $source $target
  end

  set source "$working_dir/screenrc"
  set target "$HOME/.screenrc"
  if not test -L $target
    ln -sv $source $target
  end

  set source "$working_dir/gitconfig"
  set target "$HOME/.gitconfig"
  if not test -L $target
    ln -sv $source $target
  end

  set source "$working_dir/vimrc"
  set target "$HOME/.vimrc"
  if not test -L $target
    ln -sv $source $target
  end

  if test -x (which git)
    set vim_bundle_dir "$HOME/.vim/bundle"
    mkdir -p $vim_bundle_dir
    pushd $vim_bundle_dir

    set vim_plugin_clone_urls \
      git@github.com:rking/ag.vim.git \
      git@github.com:ctrlpvim/ctrlp.vim.git \
      git@github.com:editorconfig/editorconfig-vim.git \
      git@github.com:scrooloose/nerdtree.git \
      git@github.com:scrooloose/syntastic.git \
      git@github.com:tpope/vim-fugitive.git \
      git@github.com:pangloss/vim-javascript.git \
      git@github.com:tpope/vim-pathogen.git \
      git@github.com:tristen/vim-sparkup.git \

    for clone_url in $vim_plugin_clone_urls
      set dirname (basename $clone_url | sed 's/\.git//')
      if not test -d $dirname
        git clone $clone_url &
      end
    end

    popd

    set repos_dir "$HOME/repos"
    mkdir -p $repos_dir
    pushd $repos_dir
    if not test -d n
      git clone git@github.com:tj/n.git
      pushd n; and make install; and popd
      n stable
    end
    if not test -d z-fish
      git clone git@github.com:sjl/z-fish.git
    end
    popd
  end

  if test -x (which npm)
    set node_modules_dir /usr/local/lib/node_modules
    set modules eslint babel-eslint eslint-plugin-react

    for module in $modules
      set module_dir "$node_modules_dir/$module"
      if not test -d $module_dir
        npm -g install $module
      end
    end
  end
end
