function install_from_github
  set repos_dir "$HOME/repos"
  mkdir -p $repos_dir
  pushd $repos_dir

  install_z_fish

  popd
end
