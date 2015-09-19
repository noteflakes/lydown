require 'thor'

module Lydown::CLI
  class Commands < Thor
    desc "version", "show Lydown version"
    def version
      require 'lydown/version'
      
      puts "Lydown version #{Lydown::VERSION}"
      exit!(0)
    end

    desc "compile [PATH]", "compile the lydown source at PATH"
    method_option :format, aliases: '-f', 
      default: 'pdf', desc: 'Set output format (pdf/png/ly/midi/mp3)', 
      enum: %w{pdf png ly midi mp3}
    method_option :png, type: :boolean, desc: 'Set PNG output format'
    method_option :ly, type: :boolean, desc: 'Set Lilypond output format'
    method_option :midi, type: :boolean, desc: 'Set MIDI output format'
    method_option :mp3, type: :boolean, desc: 'Set MP3 output format'

    method_option :parts, aliases: '-p',
      desc: 'Compile only the specified parts (comma separated)'
    method_option :movements, aliases: '-m',
      desc: 'Compile only the specified movements (comma separated)'
    method_option :score_only, type: :boolean, aliases: '-s',
      desc: 'Compile score only'
    method_option :parts_only, type: :boolean, aliases: '-n',
      desc: 'Compile parts only'
    method_option :output, aliases: '-o',
      desc: 'Set output path'
    method_option :open_target, type: :boolean, aliases: '-O',
      desc: 'Open output file after compilation'
    method_option :separate, type: :boolean, aliases: '-S',
      desc: 'Create separate file for each movement'
    method_option :verbose, type: :boolean
    def compile(*args)
      require 'lydown'
      
      opts = Lydown::CLI::Support.copy_options(options)
      opts[:path] = args.first || '.'
      
      # Set format based on direct flag
      opts[:format] = opts[:format].to_sym if opts[:format]
      [:png, :ly, :midi, :mp3].each {|f| opts[:format] = f if opts[f]}

      opts[:parts] = opts[:parts].split(',') if opts[:parts]
      opts[:movements] = opts[:movements].split(',') if opts[:movements]
      
      # Detect work directory
      Lydown::CLI::Support.detect_work_directory(opts)
      Lydown::CLI::Support.detect_filename(opts)
      
      p opts

      if (opts[:format] == :midi) || (opts[:format] == :mp3)
        opts[:score_only] = true
        opts[:parts_only] = false
      end

      # compile score
      unless opts[:parts_only] || opts[:parts]
        $stderr.puts "Processing score..."
        Lydown::CLI::Compiler.process(opts.merge(mode: :score, parts: nil))
      end

      # compile parts
      unless opts[:score_only]
        $stderr.puts "Processing parts..."
        Lydown::CLI::Compiler.process(opts.merge(mode: :part))
      end
    end
  
    desc "proof [PATH]", "start proofing mode on source at PATH"
    method_option :format, aliases: '-f', 
      default: 'pdf', desc: 'Set output format (pdf/png/ly)', 
      enum: %w{pdf png ly}
    method_option :include_parts, aliases: '-i', desc: 'Include parts (comma separated)'
    def proof(*args)
      require 'lydown'

      opts = Lydown::CLI::Support.copy_options(options)
      opts[:path] = args.first || '.'

      opts[:proof_mode] = true
      opts[:include_parts] = opts[:include_parts] && opts[:include_parts].split(',')
      opts[:open_target] = true
    
      Lydown::CLI::Support.detect_work_directory(opts)
      Lydown::CLI::Support.detect_filename(opts)

      Lydown::CLI::Proofing.start_proofing(opts)
    end
    
    desc "translate [PATH]", "translate source at PATH into lydown code"
    def translate(*args)
      require 'lydown'

      opts = Lydown::CLI::Support.copy_options(options)
      opts[:path] = args.first || '.'
    
      Lydown::CLI::Translation.process(opts)
    end
    
    def method_missing(method, *args)
      args = ["compile", method.to_s] + args
      self.class.start(args)
    end
  
    default_task :compile

    # Allow default task with test as path (should we be doing this for other 
    # Object instance methods?)
    undef_method(:test)
  end
end