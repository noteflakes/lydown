module Lydown::CLI::Compiler
  class << self
    def output_filename(opts)
      fn = opts[:output_filename]
      if opts[:movements] && opts[:movements].size == 1
        fn << "-#{opts[:movements].first}"
      end
      if opts[:parts] && opts[:parts].size == 1
        fn << "-#{opts[:parts].first}"
      end
      fn
    end
    
    def process(opts)
      t1 = Time.now
      opts = opts.deep_clone
      # translate lydown code to lilypond code
      ly_code = ''
      begin
        opts[:path] = opts[:source_filename]
        opts[:nice_error] = true
        work = Lydown::Work.new(opts)
        ly_code = work.to_lilypond(opts)
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
      
      opts[:output_target] = output_filename(opts)

      if opts[:format] == :ly
        unless opts[:output_target]
          STDOUT << ly_code
        else
          begin
            File.open(opts[:output_target] + '.ly', 'w+') do |f|
              f.write ly_code
            end
          rescue => e
            $stderr.puts "#{e.class}: #{e.message}"
          end
        end
      else
        compile(ly_code, opts)
      end
      t2 = Time.now
      $stderr.puts "Elapsed: #{'%.1f' % [t2-t1]}s"
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
      open_target(opts)
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
