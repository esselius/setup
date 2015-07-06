function gp
  set BRANCH (git rev-parse --abbrev-ref HEAD)
  git push --set-upstream origin $BRANCH 
end
