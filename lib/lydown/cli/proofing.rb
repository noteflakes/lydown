require 'directory_watcher'

module Lydown::CLI::Proofing
  class << self
    def start_proofing(opts)
      $stderr.puts "Proof mode: #{source} -> #{opts[:output_filename]}"

      trap("INT") {return}
      watch(opts)
      loop {sleep 1000}
    ensure
      unwatch
    end
    
    def watch(opts)
      unwatch # teardown previous watcher
      
      source = opts[:source_filename]
      Lydown::CLI::Diff.fill_cache(source)
      @last_proof_path = nil
      
      @watcher = DirectoryWatcher.new(source, glob: ["**/*.ld"], pre_load: true)
      
      @watcher.interval = 0.25
      @watcher.add_observer do |*events|
        events.each do |e|
          handle_changed_file(e, opts) if e.type == :modified
        end
      end
      @watcher.start
    end
    
    def unwatch
      return unless @watcher

      @watcher.stop
      @watcher = nil
    end
    
    def handle_changed_file(event, opts)
      path = File.expand_path(event.path)
      if path =~ /^#{opts[:source_filename]}\/(.+)/
        path = $1
      end
      @last_proof_path = event.path unless File.basename(event.path) == 'movement.ld'
      if @last_proof_path
        file_opts = opts.deep_merge(opts_for_path(@last_proof_path, opts))
        file_opts[:base_path] = path
        process(file_opts)
      end
    rescue => e
      puts e.class
      puts e.message
      puts e.backtrace.join("\n")
    end
    
    def opts_for_path(path, opts)
      path = path.gsub('/./', '/')
      part = File.basename(path, '.*')
      base = opts[:source_filename] || '.'
      if base == '.'
        base = File.expand_path(base)
      end
      dir = File.dirname(path)
      if dir =~ /^\.\/(.+)$/
        dir = $1
      end
      if dir =~ /#{base}\/([^\/]+)/
        mvt = $1
      else
        mvt = nil
      end
      
      opts = {}.deep!
      opts[:movements] = [mvt]
      if opts[:score_only]
        opts[:mode] = :score
      else
        opts[:parts] = [part]
        opts[:mode] = :proof
        opts[:line_range] = Lydown::CLI::Diff.diff_line_range(path)
      end
      
      opts
    end
    
    def process(opts)
      if opts[:line_range] != [nil, nil]
        t = Time.now.strftime("%H:%M:%S")
        unless opts[:silent]
          $stderr.puts "[#{t}] Changed: #{opts[:base_path]} \
            (lines #{opts[:line_range][0]}..#{opts[:line_range][1]})"
        end
        Lydown::CLI::Compiler.process(opts)
      end
    end
  end
end