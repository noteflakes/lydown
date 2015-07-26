require 'directory_watcher'

module Lydown::CLI::Proofing
  class << self
    def start_proofing(opts)
      source = opts[:source_filename]
      
      Lydown::CLI::Diff.fill_cache(source)
      
      $stderr.puts "Proof mode: #{source} -> #{opts[:output_filename]}"
      last_proof_path = nil

      watch_directory(source, opts)
    end
    
    def watch_directory(source, opts)
      dw = DirectoryWatcher.new(
        File.expand_path(source),
        glob: ["**/*.ld"],
        pre_load: true
      )
      dw.interval = 0.25

      dw.add_observer do |*args|
        args.each do |e|
          if e.type == :modified
            path = File.expand_path(e.path)
            if path =~ /^#{File.expand_path(source)}\/(.+)/
              path = $1
            end
            last_proof_path = e.path unless File.basename(e.path) == 'movement.ld'
            if last_proof_path
              file_opts = opts.deep_merge opts_for_path(last_proof_path, opts)
              file_opts[:base_path] = path
              process(file_opts)
            end
          end
        end
      end
       
      trap("INT") {return}
      dw.start
      loop {sleep 1000}
    ensure
      dw.stop
    end
    
    def globs(path)
      Dir.chdir(path) do
        dirs = Dir['*'].select { |x| File.directory?(x) }
      end
    
      dirs = dirs.map { |x| "#{x}/**/*" }
      dirs
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
        opts[:mode] = part
        opts[:line_range] = Lydown::CLI::Diff.diff_line_range(path)
      end
      
      opts
    end
    
    def process(opts)
      if opts[:line_range] != (nil..nil)
        t = Time.now.strftime("%H:%M:%S")
        $stderr.puts "[#{t}] Changed: #{opts[:base_path]} (lines #{opts[:line_range].inspect})"
        Lydown::CLI::Compiler.process(opts)
      end
    end
  end
end