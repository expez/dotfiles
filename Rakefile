task :default => [:make_links, :vendor]

def skip?(file)
  files_to_skip = ["Rakefile", "xmonad.hs", "dircolors.256dark", "locale.conf", "gitexcludes",
    "gitattributes"]
    files_to_skip.each{ |f| return true if f.to_s == file }
  false
end

desc "Creates symbolic links in $HOME for all config files."
task :make_links do
  home = File.expand_path('~')
    puts "Creating links..."
  Dir['*'].each do |file|
    next if skip? file
    target = File.join(home, ".#{file}")
    `ln -s #{File.expand_path file} #{target}`
  end
  `ln -s #{file.expand_path "xmonad.hs"} #{File.join(home, ".xmonad", "xmonad.hs")}`
end

desc "Fetch any 3rd party libraries."
task :vendor do
  puts "Installing 3rd party libraries..."
  libs = ["https://github.com/zsh-users/antigen.git",
    "https://github.com/Expez/zsh-vcs-prompt.git"]
  vendor_dir = File.join(Dir.home, "vendor")
  Dir.mkdir(vendor_dir) unless Dir.exists?(vendor_dir)
  libs.each do |lib|
    `cd #{vendor_dir} && git clone #{lib}`
  end
end
