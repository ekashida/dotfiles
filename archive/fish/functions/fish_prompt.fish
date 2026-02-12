function fish_prompt
  set_color -o blue
  printf '%s' (date "+%H:%M:%S")

  set_color -o red
  if test (__fish_git_prompt)
    printf '%s ' (__fish_git_prompt)
  else
    printf ' '
  end

  set_color green
  printf '%s' (hostname|cut -d . -f 1)

  set_color normal
  printf ':'

  set_color -o blue
  printf '%s ' (prompt_pwd)

  set_color normal
  printf '$ '
end
