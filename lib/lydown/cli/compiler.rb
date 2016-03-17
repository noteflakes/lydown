require 'lydown/cli/output'
require 'combine_pdf'

module Lydown::CLI::Compiler
  class << self
    PARALLEL_COMPILE_OPTIONS = {
      progress: {
        title: 'Compile',
        format: Lydown::CLI::PROGRESS_FORMAT
      }
    }
    
    PARALLEL_COLLATE_OPTIONS = {
      progress: {
        title: 'Collate',
        format: Lydown::CLI::PROGRESS_FORMAT
      }
    }
    
    def process(opts)
      @start_time = Time.now

      opts = opts.deep_clone
      work = create_work_from_opts(opts)
      
      jobs = create_jobs_from_opts(work, opts)
      
      # check if no jobs were created. This could happen when lydown processes
      # parts but no parts are found
      if jobs[:compile].empty?
        $stderr.puts "No parts found."
        return
      end
      
      process_jobs(work, jobs, opts)
      
      now = Time.now
      unless opts[:silent] || opts[:format] == :midi
        $stderr.puts "Elapsed: #{'%.1f' % [now - @start_time]}s"
      end
    end
    
    def create_jobs_from_opts(work, opts)
      jobs = {compile: [], collate: {}}
      case opts[:mode]
      when :score
        if opts[:separate]
          # If separate flag is specified, compile each movement separately
          work.context[:movements].keys.each do |m|
            add_compile_job(jobs, work, opts.merge(movements: [m]))
          end
        else
          add_compile_job(jobs, work, opts)
        end
      when :part
        # If parts are not specified, compile all extractable parts
        parts = opts[:parts] || work.context.part_list_for_extraction(opts)
        
        parts.each {|p| add_compile_job(jobs, work, opts.merge(parts: p))}
      when :proof
        add_compile_job(jobs, work, opts)
      end
      jobs
    end
    
    def add_compile_job(jobs, work, opts)
      if opts[:separate] || (opts[:format] != :pdf)
        jobs[:compile] << opts
      else
        # For now we disable dividing into bookparts, as we have a problem
        # With page numbers (each bookpart will start at 1).
        return jobs[:compile] << opts
        
        bookparts = Lydown::Rendering::Movement.bookparts(
          work.context, opts.merge(part: opts[:parts])
        )
        if bookparts.size == 1
          jobs[:compile] << opts
        else
          # If compiling pdfs, compilation can be sped up by breaking
          # the work into bookparts (on page break boundaries), compiling
          # them in parallel, and then collating the files into a single PDF.

          bookpart_files = []
          bookparts.each do |movements|
            tmp_target = Tempfile.new('lydown').path
            bookpart_files << tmp_target
            jobs[:compile] << opts.merge(
              output_target: tmp_target, temp: true, open_target: false,
              movements: movements
            )            
          end
          jobs[:collate][output_filename(opts)] = bookpart_files
        end
      end
    end
    
    def process_jobs(work, jobs, opts)
      if jobs[:compile].size == 1
        run_compile_job(work, jobs[:compile][0])
      else
        Parallel.each(jobs[:compile], PARALLEL_COMPILE_OPTIONS.clone) do |job|
          job = job.deep_clone
          job[:no_progress_bar] = true
          run_compile_job(work, job)
        end
      end
      
      collate_pdfs(jobs[:collate], opts) unless jobs[:collate].empty?
    end
    
    def collate_pdfs(collate_map, opts)
      if collate_map.size == 1
        collate_bookparts_into_pdf(collate_map.keys[0], collate_map.values[0], opts)
      else
        Parallel.each(collate_map, PARALLEL_COLLATE_OPTIONS.clone) do |fn, tempfiles|
          collate_bookparts_into_pdf(fn, tempfiles, opts)
        end
      end
    end
    
    def collate_bookparts_into_pdf(output_filename, source_filenames, opts)
      pdf = CombinePDF.new
      source_filenames.each do |fn|
        pdf << CombinePDF.load(fn + ".pdf")
      end
      pdf.save output_filename + ".pdf"
      
      system("open #{output_filename}.pdf") if opts[:open_target]
    end
    
    def run_compile_job(work, opts)
      ly_code = work.to_lilypond(opts)
      opts[:output_target] = output_filename(opts) unless opts[:temp]

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

      if opts[:edition]
        fn << "-#{opts[:edition]}"
      end
      
      if opts[:movements] && opts[:movements].size == 1
        fn << "-#{opts[:movements].first}"
      end
      if opts[:parts] && (opts[:parts].is_a?(String) || (opts[:parts].size == 1))
        part_name = opts[:parts].is_a?(String) ? opts[:parts] : opts[:parts].first
        fn << "-#{part_name}"
      elsif (opts[:mode] == :score) && !([:midi, :mp3].include? opts[:format])
        # Don't add score postfix for midi or mp3 compilation
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
      filename = "#{opts[:output_target]}.#{opts[:format] || 'pdf'}"
      
      unless File.file?(filename)
        filename2 = "#{opts[:output_target]}-page1.#{opts[:format]}"
        unless File.file?(filename2)
          raise "Could not find target file #{filename}"
        else
          filename = filename2
        end
      end
      
      if opts[:format] == :midi
        open_midi_target(filename, opts)
      else
        system("open #{filename}")
      end
    end
    
    def open_midi_target(filename, opts)
      now = Time.now
      unless opts[:silent]
        $stderr.puts "Elapsed: #{'%.1f' % [now - @start_time]}s"
      end

      $stderr << "Playing #{filename}..."
      Open3.popen2e("timidity #{filename}") do |input, output, wait_thr|
        begin
          prev_handler = trap("INT") do
            Process.kill("INT", wait_thr.pid)
            prev_handler.call if prev_handler
          end
          input.close
          output.read
          output.close
        ensure
          trap("INT", prev_handler)
        end
      end
    end
  end
end
