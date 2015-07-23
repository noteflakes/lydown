require 'yaml'

module Lydown::CLI::Translation
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
    
    def process_directory(path)
      macros = load_macros(path)
      Dir["#{path}/*"].entries.each do |entry|
        if File.file?(entry) && (entry =~ /\.rpl$/)
          process_file(entry)
        elsif File.directory?(entry)
          process_directory(entry)
        end
      end
    end
    
    def process_file(path)
      ext = File.extname(path)
      base_path = ext == '.rpl' ? path.gsub(/#{ext}$/, '') : path
      output_path = base_path + '.ld'
      lyrics_path = base_path + '.lyr'
      figures_path = base_path + '.fig'
      
      puts "translating #{path}"
      
      code = {
        path: path,
        ripple: IO.read(path),
        lyrics: File.file?(lyrics_path) && IO.read(lyrics_path),
        figures: File.file?(figures_path) && IO.read(figures_path),
        macros: macros_for_path(path)
      }
      
      ld_code = Lydown::Translation.process(code)

      File.open(output_path, 'w+') {|f| f.write(ld_code)}
    end
    
    WORK_FILENAME = '_work.yml'
    MOVEMENT_FILENAME = '_movement.yml'
    
    PATH_MACROS = {}
    
    def macros_for_path(path)
      PATH_MACROS[path] ||= load_macros(path)
    end
    
    def load_macros(path)
      base_dir = File.directory?(path) ? path : File.dirname(path)
      parent_dir = File.expand_path(File.join(base_dir, '..'))
      
      yml = 
        (YAML.load_file(File.join(parent_dir, WORK_FILENAME)) rescue nil) || 
        (YAML.load_file(File.join(base_dir, WORK_FILENAME)) rescue nil) ||
        {}
      macros = yml['macros'] || {}
      
      yml = 
        (YAML.load_file(File.join(base_dir, MOVEMENT_FILENAME)) rescue nil) ||
        {}
      macros.merge(yml['macros'] || {})
    end
  end
end