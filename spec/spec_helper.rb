require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/lydown')

EXAMPLES_PATH = File.join(File.expand_path(File.dirname(__FILE__)), 'examples')

$spec_mode = true

$old_stderr, $stderr = $stderr, StringIO.new

def load_example(name, opts = {})
  content = IO.read(File.join(EXAMPLES_PATH, name))
  opts[:strip] ? content.strip_whitespace : content
end

class String
  def strip_whitespace
    gsub(/\n/, ' ').gsub(/[ ]{2,}/, ' ').strip
  end
end

class Sink
  def method_missing(m, *args)
    # do nothing
  end
end

# Inhibit command line output
module Lydown::CLI
  # Simple wrapper around ProgressBar
  def self.show_progress(title, total)
    yield Sink.new
  end
end

# Inhibit parallel progress bar
Lydown::Work::PARALLEL_PARSE_OPTIONS.delete(:progress)
Lydown::Work::PARALLEL_PROCESS_OPTIONS.delete(:progress)

def verify_example(name, result_name = nil, opts = {})
  lydown = LydownParser.parse(load_example("#{name}.ld"))
  work = Lydown::Work.new
  work.context['end_barline'] = 'none'
  work.translate(lydown)
  ly = work.to_lilypond(opts.merge(no_lib: true)).strip_whitespace

  ex = load_example("#{result_name || name}.ly", strip: true)
  expect(ly).to eq(ex)
  # expect {Lydown::Lilypond.compile(ly)}.not_to raise_error
end

require 'fileutils'

# Install hooks to create and delete tmp directory
RSpec.configure do |config|
  config.before(:all) do
    FileUtils.mkdir('spec/tmp') rescue nil
  end
  config.after(:all) do
    FileUtils.rmdir('spec/tmp') rescue nil
  end
end