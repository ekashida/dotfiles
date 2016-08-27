function install_n
  if not test -d n
    git clone git@github.com:tj/n.git
    pushd n; and make install; and popd
    n stable
  end
end
