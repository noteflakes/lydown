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
      rescue LydownError => e
        $stderr.puts e.message
        $stderr.puts e.backtrace.join("\n")
        exit 1
      rescue => e
        $stderr.puts "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
        exit 1
      end
      
      opts[:output_target] = output_filename(opts)

      if opts[:format] == 'ly'
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
      opts = opts.deep_clone
      begin
        Lydown::Lilypond.compile(ly_code, opts)
      rescue LydownError => e
        $stderr.puts e.message
        $stderr.puts e.backtrace.join("\n")
      rescue => e
        $stderr.puts "#{e.class}: #{e.message}"
        $stderr.puts e.backtrace.join("\n")
      end

      if opts[:open_target]
        filename = "#{opts[:output_target]}.#{opts[:format]}"
        
        unless File.file?(filename)
          filename = "#{opts[:output_target]}-page1.#{opts[:format]}"
        end

        # Mac OSX specific probably
        system("open #{filename}")
      end
    end
  end
end
