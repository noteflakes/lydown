require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/lydown')

def load_example(name)
  IO.read(File.join(File.expand_path(File.dirname(__FILE__)), name)).strip_whitespace
    
end

class String
  def strip_whitespace
    gsub(/\n/, ' ').gsub(/[ ]{2,}/, ' ').strip
  end
end