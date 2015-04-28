require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/lydown')

EXAMPLES_PATH = File.join(File.expand_path(File.dirname(__FILE__)), 'examples')

def load_example(name)
  IO.read(File.join(EXAMPLES_PATH, name))
end

class String
  def strip_whitespace
    gsub(/\n/, ' ').gsub(/[ ]{2,}/, ' ').strip
  end
end

def verify_example(name, result_name = nil)
  lydown = LydownParser.parse(load_example("#{name}.ld"))
  opus = Lydown::Opus.new
  opus.translate(lydown)
  ly = opus.render.strip_whitespace
  expect(ly).to eq(load_example("#{result_name || name}.ly").strip_whitespace)
end