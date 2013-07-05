#!/usr/bin/env ruby

Dir.chdir("/opt/boxen") do

  File.open(File.expand_path("~/.config/fish/boxen.fish"), "w") do |f|

    ["env.sh", *Dir.glob("env.d/*.sh")].each do |file|

      File.readlines(file).each do |line|
        case line
        when /^#!/
          f.puts "#!/usr/bin/env fish"
        when /^\s*(?:export )?(.*?)=(.*)/
          name, content = $1, $2
          content.gsub!(/:\$/, ' $') # yay fuzzy heuristics
          content.gsub!(/`(.*)`/) {
            contents = $1
            contents.sub!(/^([^\s]+?)=([^\s]+)/, 'env \1=\2')
            "(#{contents})"
          }
          content.gsub!(/\$\{(.*)\}/, '(\1)')
          f.print "set -x #{name} #{content}\n"
        when /^\s*set [\-\+][eu]/
          f.print "# #{line.chomp}\n"
        when /^\s*#.*/
          f.print line
        when /^\s*$/
          f.print line
        else
          f.print "###### PARSE ERR: #{line.chomp}\n"
        end
      end

    end

    f.puts "set -x PATH /opt/boxen/rbenv/shims /opt/boxen/rbenv/bin $PATH"
    f.puts "rbenv rehash 2>/dev/null"

    f.puts "function git ; hub $argv ; end"

  end
end