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

def verify_example(name)
  @opus.compile(load_example("example-#{name}.ld"))
  ly = @opus.to_lilypond.strip_whitespace
  puts ly
  expect(ly).to eq(load_example("example-#{name}.ly").strip_whitespace)
end