function clone-org
  mkdir -p ~/code/$argv
  pushd ~/code/$argv
  curl -u esselius -s "https://api.github.com/orgs/$argv/repos?per_page=200" | \
  ruby -r json -e 'JSON.load(STDIN.read).each { |repo| system("git clone " + \
  repo["ssh_url"]) }'
  popd
end
