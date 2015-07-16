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
      options[:output_filename] ||= 'lydown' unless options[:format] == 'ly'
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
end
