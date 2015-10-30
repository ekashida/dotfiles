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


  if test -x (which git)
    set -l vim_bundle_dir (printf '%s/.vim/bundle' $HOME)
    mkdir -p $vim_bundle_dir
    pushd $vim_bundle_dir
    [ ! -e ag.vim           ]; and git clone git@github.com:rking/ag.vim.git
    [ ! -e ctrlp.vim        ]; and git clone git@github.com:ctrlpvim/ctrlp.vim.git
    [ ! -e editorconfig-vim ]; and git clone git@github.com:editorconfig/editorconfig-vim.git
    [ ! -e nerdtree         ]; and git clone git@github.com:scrooloose/nerdtree.git
    [ ! -e syntastic        ]; and git clone git@github.com:scrooloose/syntastic.git
    [ ! -e vim-fugitive     ]; and git clone git@github.com:tpope/vim-fugitive.git
    [ ! -e vim-javascript   ]; and git clone git@github.com:pangloss/vim-javascript.git
    [ ! -e vim-pathogen     ]; and git clone git@github.com:tpope/vim-pathogen.git
    [ ! -e vim-sparkup      ]; and git clone git@github.com:tristen/vim-sparkup.git
    popd

    set -l repos_dir (printf '%s/repos' $HOME)
    mkdir -p $repos_dir
    pushd $repos_dir
    if not test -d n
      git clone git@github.com:tj/n.git
      pushd n; and make install; and popd
    end
    popd
  end

  if test -x (which npm)
    set -l node_modules_dir /usr/local/lib/node_modules
    set -l modules eslint babel-eslint eslint-plugin-react

    for module in $modules
      set module_dir "$node_modules_dir/$module"
      if not test -d $module_dir
        npm -g install $module
      end
    end
  end
end
