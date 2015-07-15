require 'diff/lcs'

module Lydown::CLI::Diff
  class << self
    CACHE = {}
    
    def cached_content(path)
      CACHE[File.absolute_path(path)] || []
    end
    
    def set_cached_content(path, content)
      CACHE[File.absolute_path(path)] = content
    end
    
    def fill_cache(dir)
      count = 0
      Dir["#{dir}/**/*.ld"].each do |path|
        set_cached_content(path, read_content(path)) rescue nil
        count += 1
      end
      puts "Cached #{count} files."
    end
    
    def read_content(path)
      IO.read(path).lines.map {|l| l.chomp}
    end
    
    def diff_line_range(path)
      new_version = read_content(path)
      old_version = cached_content(path)
      
      first = nil
      last = nil
      
      diffs = Diff::LCS.diff(old_version, new_version).each do |d|
        d.each do |r|
          line = r.to_a[1]
          first = line if first.nil? || line < first
          last = line if last.nil? || line > last
        end
      end
      
      set_cached_content(path, new_version)
      
      (first + 1)..(last + 1)
    rescue => e
      STDERR << e.message
      STDERR << e.backtrace.join("\n")
      nil..nil
    end
  end
end