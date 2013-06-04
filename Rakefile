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
  sh "if [ -d ~/.vim/janus ]; then cd ~/.vim; rake; else curl -Lo- https://bit.ly/janus-bootstrap | bash; fi"
  sh "if [ -d janus/vim-powerline ]; then cd janus/vim-powerline; git pull; else git clone git@github.com:Lokaltog/vim-powerline.git janus/vim-powerline; fi"
end

desc "Do default stuff: symlink"
task :default do
  sh "rake symlink"
end
