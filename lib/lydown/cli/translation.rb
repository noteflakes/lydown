module Lydown::CLI::Compiler
  class << self
    def process(opts)
      if File.directory?(opts[:path])
        process_directory(opts[:path])
      elsif File.file?(opts[:path])
        process_file(opts[:path])
      elsif File.file?(opts[:path] + '.rpl')
        process_file(opts[:path] + '.rpl')
      end
    end
    
    def process_file(path)
      ext = File.extname(path)
      base_path = ext == '.rpl' ? path.gsub(/#{ext}$/, '') : path
      output_path = base_path + '.ld'
      lyrics_path = base_path + '.lyr'
      figures_path = base_path + '.fig'
      
      code = {
        ripple: IO.read(path),
        lyrics: File.file?(lyrics_path) && IO.read(lyrics_path),
        figures: File.file?(figures_path) && IO.read(figures_path)
      }
      
      ld_code = Lydown::Translation.process(code)

      File.open(output_path, 'w+') {|f| f.write(ld_code)}
    end
  end
end