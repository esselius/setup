def here(*paths)
  File.expand_path(File.join(File.dirname(__FILE__), *paths))
end

def dotfiles
  Dir[here('*')].map do |path|
    File.basename(path)
  end.reject do |path|
    path == "Rakefile" or path =~ /^README/
  end
end

desc "Symlinks dotfiles"
task :symlink do
  dotfiles.each do |dotfile|
    link = File.expand_path("~/.#{dotfile}")
    unless File.exists?(link)
      sh "ln -s #{here(dotfile)} #{link}"
    end
  end
end

desc "Removes dotfile symlinks"
task :clean do
  dotfiles.each do |dotfile|
    link = File.expand_path("~/.#{dotfile}")
    if File.symlink?(link)
      sh "unlink #{link}"
    end
  end
end

desc "Installs some stuff"
task :install do
  sh "curl -Lo- https://bit.ly/janus-bootstrap | bash"
end

desc "Do default stuff: symlink"
task :default do
  sh "rake symlink"
end
