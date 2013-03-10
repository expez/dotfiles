task :default => [:install, :init_vendor]

def skip?(file)
  files_to_skip = ["Rakefile", "xmonad.hs", "dircolors.256dark", "locale.conf",
    "gitexcludes", "gitattributes", "42-asd-link-farm"]
    files_to_skip.each{ |f| return true if f.to_s == file }
  false
end

desc "Installs all the dotfiles to $HOME, using symbolic links."
task :install do
  puts "Creating links..."
  Dir['*'].each do |file|
    next if skip? file
    target = File.join(Dir.home, ".#{file}")
    `ln -s #{File.expand_path file} #{target}`
  end

  `ln -s #{File.expand_path "xmonad.hs"} #{File.join(Dir.home, ".xmonad", "xmonad.hs")}`

  dir =  "#{Dir.home}/.config/common-lisp/source-registry-conf.d"
  FileUtils.mkdir_p dir
  `ln -s #{File.expand_path "42-asd-link-farm"} #{dir}/42-asd-link-farm`
end

vendor_libs = ["zsh-users/antigen", "expez/zsh-vcs-prompt"]

desc "Installs 3rd party dependencies to $HOME/vendor"
task :init_vendor do
  puts "Installing 3rd party libraries...\n"
  vendor_dir = File.join(Dir.home, "vendor")
  Dir.mkdir(vendor_dir) unless Dir.exists?(vendor_dir)
  vendor_libs.each do |lib|
    repo = "https://github.com/#{lib}"
    print "Installing from #{repo}..."
    `cd #{vendor_dir} && git clone #{repo}`
    print "DONE\n"
  end
end

desc "Update all 3rd party libraries."
task :update_vendor do
  puts "Updating 3rd party libraries...\n"
  dirs = vendor_libs
  dirs.each { |path| path.slice!(/.*\//) }
  dirs.each do |dir|
    print "Updating #{dir}..."
    `cd #{File.join(Dir.home, "vendor", dir)} && git pull`
    print "DONE\n"
  end
end
