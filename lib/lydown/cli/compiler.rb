require 'lydown/cli/output'

module Lydown::CLI::Compiler
  class << self
    PARALLEL_COMPILE_OPTIONS = {
      progress: {
        title: 'Compile',
        format: Lydown::CLI::PROGRESS_FORMAT
      }
    }
    
    def process(opts)
      t1 = Time.now

      case opts[:mode]
      when :score
        $stderr.puts "Process score..."
      when :part
        $stderr.puts "Process #{output_filename(opts)} parts..."
      end
      
      opts = opts.deep_clone
      work = create_work_from_opts(opts)
      
      jobs = create_jobs_from_opts(work, opts)
      process_jobs(work, jobs)
      
      t2 = Time.now
      $stderr.puts "Elapsed: #{'%.1f' % [t2-t1]}s"
    end
    
    def create_jobs_from_opts(work, opts)
      jobs = []
      case opts[:mode]
      when :score
        if opts[:separate]
          work.context[:movements].keys.each do |m|
            jobs << opts.merge(movements: [m])
          end
        else
          jobs << opts
        end
      when :part
        parts = opts[:parts] ? 
          opts[:parts].split(',') : work.context.part_list_for_extraction(opts)
        
        parts.each {|p| jobs << opts.merge(parts: p)}
      end
      jobs
    end
    
    def process_jobs(work, jobs)
      if jobs.size == 1
        run_compile_job(work, jobs[0])
      else
        Parallel.map(jobs, PARALLEL_COMPILE_OPTIONS.clone) do |opts|
          opts = opts.deep_clone
          opts[:no_progress_bar] = true
          run_compile_job(work, opts)
        end
      end
    end
    
    def run_compile_job(work, opts)
      ly_code = work.to_lilypond(opts)
      opts[:output_target] = output_filename(opts)

      if opts[:format] == :ly
        process_ly_target(ly_code, opts)
      else
        compile(ly_code, opts)
      end
    rescue => e
      if e.is_a?(LydownError)
        $stderr.puts e.message
      else
        $stderr.puts "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
      end
      if opts[:proof_mode]
        `osascript -e beep`
        return
      else
        exit(1)
      end
    end
    
    def process_ly_target(ly_code, opts)
      unless opts[:output_target]
        STDOUT << ly_code
      else
        File.open(opts[:output_target] + '.ly', 'w+') do |f|
          f.write ly_code
        end
        open_target(opts) if opts[:open_target]
      end
    end
    
    def output_filename(opts)
      fn = opts[:output_filename].dup
      if opts[:movements] && opts[:movements].size == 1
        fn << "-#{opts[:movements].first}"
      end
      if opts[:parts] && (opts[:parts].is_a?(String) || (opts[:parts].size == 1))
        part_name = opts[:parts].is_a?(String) ? opts[:parts] : opts[:parts].first
        fn << "-#{part_name}"
      elsif opts[:mode] == :score
        fn << '-score'
      end
      fn
    end
    
    def create_work_from_opts(opts)
      opts[:path] = opts[:source_filename]
      opts[:nice_error] = true
      Lydown::Work.new(opts)
    end

    def compile(ly_code, opts)
      if opts[:format] == 'mp3'
        return compile_mp3(ly_code, opts)
      end
      
      opts = opts.deep_clone
      Lydown::Lilypond.compile(ly_code, opts)
      open_target(opts) if opts[:open_target]

    rescue CompilationAbortError
      $stderr.puts "Compilation aborted"
    rescue LydownError => e
      $stderr.puts e.message
      $stderr.puts e.backtrace.join("\n")
    rescue => e
      $stderr.puts "#{e.class}: #{e.message}"
      $stderr.puts e.backtrace.join("\n")
    end
    
    def compile_mp3(ly_code, opts)
      opts2 = opts.merge(format: 'midi').deep_clone
      Lydown::Lilypond.compile(ly_code, opts2)

      midi_filename = "#{opts[:output_target]}.midi"
      mp3_filename =  "#{opts[:output_target]}.mp3"
      cmd = "timidity -Ow -o - #{midi_filename} | lame - #{mp3_filename}"
      $stderr.puts "Converting to MP3..."
      Open3.popen2e(cmd) do |input, output, wait_thr|
        input.close
        output.read
        output.close
      end
      open_target(opts) if opts[:open_target]
    rescue CompilationAbortError
      $stderr.puts "Compilation aborted"
    end
    
    def open_target(opts)
      filename = "#{opts[:output_target]}.#{opts[:format]}"
      
      unless File.file?(filename)
        filename2 = "#{opts[:output_target]}-page1.#{opts[:format]}"
        unless File.file?(filename2)
          raise "Could not find target file #{filename}"
        else
          filename = filename2
        end
      end
      
      if opts[:format] == 'midi'
        open_midi_target(filename)
      else
        system("open #{filename}")
      end
    end
    
    def open_midi_target(filename)
      $stderr << "Playing #{filename}..."
      Open3.popen2e("timidity #{filename}") do |input, output, wait_thr|
        input.close
        output.read
        output.close
      end
    end
  end
end
