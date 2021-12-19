complete -f -c glo -a "(ghq list | sort)"
function glo
  cd (ghq root)/$argv
end
