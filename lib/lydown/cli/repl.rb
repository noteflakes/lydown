require 'fileutils'
require 'readline'

module Lydown::CLI::REPL
  class << self
    def run
      require 'lydown'
      
      orig_dir = FileUtils.pwd
      
      trap("INT") do
        Lydown::CLI::Proofing.unwatch # stop file watcher for proofing
        save_history
        puts
        FileUtils.cd(orig_dir)
        exit(0)
      end
      
      load_history
      
      update_proofing_watcher(orig_dir)
      
      while line = Readline.readline(prompt, true).chomp
        maintain_clean_history(line)
        process(line)
      end
    end
    
    def maintain_clean_history(line)
      if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
        Readline::HISTORY.pop
      end
    end
    
    HISTORY_FN = File.expand_path('~/.lydown_history')
    
    def load_history
      IO.read(HISTORY_FN).lines.each do |l|
        Readline::HISTORY << l.chomp
      end
    rescue
    end
    
    def save_history
      File.open(HISTORY_FN, 'w+') do |f|
        Readline::HISTORY.to_a.each do |l|
          f.puts l
        end
      end
    rescue => e
      puts "Failed to save history: #{e.message}"
    end
    
    def prompt
      "#{File.basename(FileUtils.pwd)}♫ "
    end
    
    def process(line)
      if line =~ /^([a-z]+)\s?(.*)$/
        cmd = $1
        args = $2
        cmd_method = :"handle_#{cmd}"
        if respond_to?(cmd_method)
          send(cmd_method, args)
        else
          handle_default(line)
        end
      end
    end
    
    HELP = <<EOF
    
    pwd                 Print working directory
    cd <path>           Change working directory
    ls [<path>]         Show lydown files in working directory

    cat <file>          Show content of file
    cat <file>:<line>   Show content of file at specified line, or range of
                        lines, e.g. cat flute1:13, or cat flute1:25-27

    edit <file>         Edit file using vim
    edit <file>:<line>  Edit file using vim, place cursor at specified line
    
    score               Compile & open score
    midi                Compile & open MIDI file
    <part>              Compile & open part
    
    To exit press ctrl-C
EOF
    
    def handle_help(args)
      puts HELP; puts
    end
    
    def handle_pwd(args)
      puts FileUtils.pwd
    end
    
    def handle_cd(args)
      path = File.expand_path(args)
      FileUtils.cd(path)
      update_proofing_watcher(path)
    rescue => e
      puts e.message
    end
    
    def handle_git(args)
      puts `git #{args}`
    end
    
    def handle_edit(args)
      if args =~ /(.*):(\d+)$/
        fn = $1; line = $2
      else
        fn = args; line = nil
      end
      
      return unless fn = validate_filename(fn)

      if line
        system "vim +#{line} #{fn} -c 'normal zz'"
      else
        system "vim #{fn}"
      end
    end
    
    def validate_filename(fn)
      unless File.file?(fn)
        fn += '.ld'
        unless File.file?(fn)
          puts "File not found"
          return nil
        end
      end
      fn
    end
    
    def update_proofing_watcher(path)
      opts = {path: path, proof_mode: true, open_target: true, 
        no_progress_bar: true, silent: true, repl: true}
      Lydown::CLI::Support.detect_work_directory(opts)
      Lydown::CLI::Support.detect_filename(opts)
      
      Lydown::CLI::Proofing.watch(opts)
    end
    
    def handle_ls(args)
      system 'ls'
    end
    
    def handle_cat(args)
      if args =~ /^([^\s:]+):?(\d+)?\-?(\d+)?$/
        fn = $1
        line_start = $2
        line_end = $3
        
        if line_start
          if line_end
            line_range = (line_start.to_i - 1)..(line_end.to_i - 1)
          else
            line_range = (line_start.to_i - 1)..(line_start.to_i - 1)
          end
        else
          line_range = nil
        end
          
        return unless fn = validate_filename(fn)
        
        content = IO.read(fn)
        unless line_range
          puts content
        else
          puts content.lines[line_range].join
        end
      end
    end
    
    def handle_score(args)
      opts = {path: '.', open_target: true, mode: :score, repl: true}
      $stderr.puts "Processing score..."
      compile(opts)
    end
    
    def handle_midi(args)
      opts = {path: '.', open_target: true, mode: :score, format: :midi, 
        repl: true
      }
      $stderr.puts "Processing MIDI..."
      compile(opts)
    end
    
    def handle_default(args)
      opts = {}
      
      args.split(',').map(&:strip).each do |a|
        if File.file?(a) || File.file?("#{a}.ld")
          opts = {path: '.', parts: [a], mode: :part, open_target: true, repl: true}
        elsif File.directory?(a)
          opts = {path: '.', movements: [a], mode: :score, open_target: true, repl: true}
        else
          raise LydownError, "Invalid path specified - #{a}"
        end
        $stderr.puts "Processing #{a}..."
        compile(opts)
      end
    rescue => e
      # do nothing
    end
    
    def compile(opts)
      Lydown::CLI::Support.detect_work_directory(opts)
      Lydown::CLI::Support.detect_filename(opts)

      prev_handler = trap("INT") do
        puts
      end
      Lydown::CLI::Compiler.process(opts)
    ensure
      trap("INT", prev_handler)
    end
  end
end
