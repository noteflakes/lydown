require 'lydown/errors'
require 'lydown/cli/output'
require 'lydown/cli/signals'

require 'tempfile'
require 'fileutils'
require 'open3'

module Lydown
  module Lilypond
    class << self
      MINIMAL_LILYPOND_VERSION = Gem::Version.new('2.18')
      
      def lilypond_path
        # detect lyp-installed lilypond
        # path = `lyp which lilypond`.lines.last rescue nil
        # return path.chomp if path
        #
        # path = `which lilypond` rescue nil
        # return path.chomp if path && !path.empty?
        
        return 'lilypond'
      end

      # detect the lilypond version. If lilypond is not found, or the version is
      # less than the minimal supported version, display an error message.
      def detect_lilypond_version(exit_on_error)
        version = nil
        if path = lilypond_path
          msg = `#{lilypond_path} --version`
          if msg.lines.first =~ /LilyPond ([\d\.]+)/
            version = $1
          end
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
  
      def display_lilypond_version_error_msg(version)
        if version
          STDERR.puts "ERROR: The installed lilypond (version #{version}) is too old."
        else
          STDERR.puts "ERROR: No copy of lilypond found."
        end
      end

      def tmpdir
        @tmpdir ||= Dir.mktmpdir
      end
      
      def compile(source, opts = {})
        opts[:output_target] ||= 'lydown'

        if opts[:temp]
          opts[:output_filename] = opts[:output_target]
          invoke(source, opts)
        else
          invoke_with_tempfile(source, opts)
        end
        
      rescue CompilationAbortError => e
        raise e
      rescue => e
        $stderr.puts e.message
        $stderr.puts e.backtrace.join("\n") unless e.is_a?(LydownError)
        raise e
      end
      
      # Compile into a tempfile. We do this because lilypond's behavior when 
      # supplied with target filenames is broken. If it is given a target
      # path which corresponds to an existing directory name, it does not use
      # the specified path plus extension, but instead creates a file inside
      # the directory.
      def invoke_with_tempfile(source, opts)
        target = opts[:output_target].dup
        ext = ".#{opts[:format] || :pdf}"
        if target !~ /#{ext}$/
          target << ext
        end
        
        tmp_target = Tempfile.new('lydown').path
        opts[:output_filename] = tmp_target
        invoke(source, opts)
        
        # Copy tempfile to target
        if File.file?(tmp_target + ext)
          FileUtils.cp(tmp_target + ext, target)
        else
          copy_pages(tmp_target, target, ext)
        end
      end
      
      def copy_pages(source, target, ext)
        page = 1
        loop do
          source_fn = source + "-page#{page}" + ext
          break unless File.file?(source_fn)
          
          target_fn = target.dup.insert(target.index(/\.[^\.]+$/), "-page#{page}")
          
          FileUtils.cp(source_fn, target_fn)
          page += 1
        end
      end
      
      # In order to be able to run the lyp lilypond wrapper (if present),
      # we need to reset the environment variables set by bundler when running
      # lydown.
      RESET_ENV = {
        "_ORIGINAL_GEM_PATH" => "",
        "BUNDLE_GEMFILE" => "",
        "BUNDLE_BIN_PATH" => "",
        "RUBYOPT" => "",
        "RUBYLIB" => ""
      }
      
      # Run lilypond, pipe source into its STDIN, and capture its STDERR
      def invoke(source, opts = {})
        tmp_source_path = Tempfile.new('lydown').path
        File.open(tmp_source_path, 'w') {|f| f << source}

        cmd = format_cmd(opts, tmp_source_path)
        puts cmd if opts[:verbose]
        
        err_info = ''
        exit_value = nil
        
        Open3.popen2e(RESET_ENV, cmd) do |input, output, wait_thr|
          err_info = exec(wait_thr, input, output, opts)
          exit_value = wait_thr.value
        end
        if exit_value != 0
          if exit_value.termsig
            raise CompilationAbortError
          else
            # err_info = err_info.lines[0, 3].join
            raise LydownError, "Lilypond compilation failed:\n#{err_info}"
          end
        end
      end
      
      def format_cmd(opts, source_path)
        format = opts[:format]
        format = nil if (format == :midi) || (format == :mp3)

        cmd = "#{lilypond_path} "
        # cmd << "-dbackend=eps " if opts[:mode] == :proof
        cmd << "-o #{opts[:output_filename]} "
        cmd << "-dno-point-and-click "
        cmd << "--#{opts[:format]} " if format
        cmd << "-V " if opts[:verbose]
        cmd << source_path

        cmd
      end
      
      def exec(wait_thr, input, output, opts)
        Lydown::CLI.register_abortable_process(wait_thr.pid)
        input.close_write
        err_info = read_lilypond_progress(output, opts)
        output.close
        err_info
      ensure
        Lydown::CLI.unregister_abortable_process(wait_thr.pid)
      end
      
      LILYPOND_STATUS_LINES = %w{
        Processing
        Parsing
        Interpreting
        Preprocessing
        Finding
        Fitting
        Drawing
        Layout
        Converting
        Success:
      }
      STATUS_TOTAL = LILYPOND_STATUS_LINES.size
      
      def read_lilypond_progress(f, opts)
        info = ''
        if !opts[:verbose] && !opts[:no_progress_bar]
          Lydown::CLI::show_progress('Compile', STATUS_TOTAL) do |bar|
            while !f.eof?
              line = f.gets
              info += line
              if line =~ /^([^\s]+)/
                idx = LILYPOND_STATUS_LINES.index($1)
                bar.progress = idx + 1 if idx
              end
            end
            bar.progress = STATUS_TOTAL
          end
        elsif opts[:verbose]
          while !f.eof?
            line = f.gets
            STDERR.puts line
            info += line
          end
        else
          info = f.read
        end
        info
      end

    end
  end
end

