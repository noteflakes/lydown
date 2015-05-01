require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/lydown')

EXAMPLES_PATH = File.join(File.expand_path(File.dirname(__FILE__)), 'examples')

def load_example(name, strip = false)
  content = IO.read(File.join(EXAMPLES_PATH, name))
  strip ? content.strip_whitespace : content
end

class String
  def strip_whitespace
    gsub(/\n/, ' ').gsub(/[ ]{2,}/, ' ').strip
  end
end

def verify_example(name, result_name = nil)
  lydown = LydownParser.parse(load_example("#{name}.ld"))
  work = Lydown::Work.new
  work.process(lydown)
  ly = work.to_lilypond.strip_whitespace
  expect(ly).to eq(load_example("#{result_name || name}.ly", true))
  # expect {Lydown::Lilypond.compile(ly)}.not_to raise_error
end