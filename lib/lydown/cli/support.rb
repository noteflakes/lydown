module Lydown::CLI::Support
  def self.copy_options(options)
    opts = {}.deep!
    
    options.each {|k, v| opts[k.to_sym] = v}
    opts
  end
  
  def self.detect_filename(options)
    source = ''
    if options[:path] == '-'
      # read source from stdin
      options[:source] = STDIN.read
  
      # the output defaults to a file named lydown expect if the format is ly.
      # In that case the output will be sent to STDOUT.
      options[:output_filename] ||= 'lydown' unless options[:format] == :ly
    else
      options[:source_filename] = options[:path]
      if (options[:path] !~ /\.ld$/) and File.file?(options[:path] + ".ld")
        options[:path] += ".ld"
      end
  
      unless options[:output_filename]
        if options[:path] == '.'
          options[:output_filename] = File.basename(FileUtils.pwd)
        else
          options[:output_filename] = (options[:path] =~ /^(.+)\.ld$/) ?
            $1 : options[:path]
        end
      end
    end
  end
  
  # determine if the specified path is actually a path to a single movement of
  # a multi-movement work. If so, return the path of the work directory, and 
  # add a movement parameter. This should also take care of running proof
  # mode inside of a movement directory.
  def self.detect_work_directory(opts)
    return if opts[:movements]

    parent_dir = File.expand_path(File.join(opts[:path], '..'))
    
    if !File.exists?(File.join(opts[:path], 'work.ld')) &&
      File.exists?(File.expand_path(File.join(parent_dir, 'work.ld')))

      movement = File.basename(File.expand_path(opts[:path]))
      opts[:movements] = [movement] unless opts[:mode] == :proof
      opts[:path] = parent_dir
    end
  end
  
  MINIMAL_LILYPOND_VERSION = Gem::Version.new('2.18')
  
  # detect the lilypond version. If lilypond is not found, or the version is
  # less than the minimal supported version, display an error message.
  def self.detect_lilypond_version(exit_on_error)
    msg = `lilypond --version`
    version = nil
    if msg.lines.first =~ /LilyPond ([\d\.]+)/
      version = $1
    end
    unless version && Gem::Version.new(version) >= MINIMAL_LILYPOND_VERSION
      display_lilypond_version_error_msg(version)
      exit!(1) if exit_on_error
      version = nil
    end
    version
  rescue => e
    display_lilypond_version_error_msg(nil)
    exit!(1) if exit_on_error
  end
  
  def self.display_lilypond_version_error_msg(version)
    if version
      STDERR.puts "ERROR: The installed lilypond (version #{version}) is too old.
       You can install lilypond by running `lydown install lilypond` or by
       downloading a recent version from http://lilypond.org/"
    else
      STDERR.puts "ERROR: No copy of lilypond found.
       You can install lilypond by running `lydown install lilypond` or by
       downloading a recent version from http://lilypond.org/"
    end
  end
end




