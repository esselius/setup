function gp
  set BRANCH (git rev-parse --abbrev-ref HEAD)
  if git show-branch origin/$BRANCH > /dev/null 2>&1
    git push --force-with-lease --set-upstream origin $BRANCH $argv
  else
    git push --set-upstream origin $BRANCH $argv
  end
end
