function gp
  set BRANCH (git rev-parse --abbrev-ref HEAD)
  git push --force-with-lease --set-upstream origin $BRANCH $argv
end
