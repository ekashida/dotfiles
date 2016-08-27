function install_z_fish
  if not test -d z-fish
    git clone git@github.com:sjl/z-fish.git
  end
end
