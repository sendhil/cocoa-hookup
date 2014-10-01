 # Largely based on code from Tim Pope's Hookup Gem(https://github.com/tpope/hookup)
class CocoaHookup

  class Error < RuntimeError
  end

  class Failure < Error
  end

  def self.run(*argv)
    new.run(*argv)
  rescue Failure => e
    puts e
    exit 1
  rescue Error => e
    puts e
    exit
  end

  def run(*argv)
    if argv.first =~ /install/i
      install
    elsif argv.first =~ /post-checkout/i
      post_checkout(*argv)
    elsif argv.length == 0
      puts "Usage: 'cocoa-hookup install' to install the git hook"
    else
      raise Error, "Invalid arguments for 'cocoa-hookup'"
    end
  end

  def git_dir
    unless @git_dir
      @git_dir = %x{git rev-parse --git-dir}.chomp
      raise Error unless $?.success?
    end
    @git_dir
  end

  def post_checkout_file
    File.join(git_dir, 'hooks', 'post-checkout')
  end

  def post_checkout(*argv)
    if argv.length != 3
      puts "Invalid arguments for 'cocoa-hookup post-checkout'. Usage: 'cocoa-hookup post-checkout old-rev new-rev branching-flag'"
      return
    end

    old = argv[1]
    new = argv[2]
    branch_checkout = argv[3]

    return unless branch_checkout == "1" # Ignore if not a branch checkout

    if %x{git diff --name-only #{old} #{new}} =~ /^Podfile/
      puts "Podfile is different from last branch, updating Cocoapods..."
      system('pod install')
      system("terminal-notifier -title '#{`pwd`}' -message 'Cocoapods Updated' ")
    end
  end

  def install
    append(post_checkout_file, 0777) do |body, f|
      f.puts "#!/bin/bash" unless body
      f.puts "echo Running post-checkout script"
      f.puts %(./cocoa-hookup post-checkout "$@") if body !~ /cocoa-hookup/ #TODO: Remove ./
    end

    puts "CocoaHookup Installed"
  end

  def append(file, *args)
    Dir.mkdir(File.dirname(file)) unless File.directory?(File.dirname(file))
    body = File.read(file) if File.exist?(file)
    File.open(file, 'a', *args) do |f|
      yield body, f
    end
  end
  protected :append

end
