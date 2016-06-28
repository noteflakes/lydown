Bundler.setup(:default, :spec)
require File.expand_path('../lib/lydown', File.dirname(__FILE__))

SPEC_PATH = File.expand_path('.', File.dirname(__FILE__))
EXAMPLES_PATH = File.expand_path('examples', File.dirname(__FILE__))

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

# Inhibit cache
Cache.disable!

def verify_example(name, result_name = nil, opts = {})
  lydown = LydownParser.parse(load_example("#{name}.ld"),
    filename: File.join(EXAMPLES_PATH, "#{name}.ld")
  )
  work = Lydown::Work.new(opts)
  unless opts[:inhibit_end_barline].nil?
    work.context['global/settings/inhibit_end_barline'] = opts[:inhibit_end_barline]
  else
    work.context['global/settings/inhibit_end_barline'] = true
  end
  work.translate(lydown)
  ly_opts = opts.merge(no_lib: true, no_layout: !opts[:do_layout])
  ly = work.to_lilypond(ly_opts).strip_whitespace

  ex = load_example("#{result_name || name}.ly", strip: true)
  expect(ly).to eq(ex)
  if opts[:compile]
    expect {Lydown::Lilypond.compile(ly)}.not_to raise_error
  end
end

def translate_example(name, opts = {})
  lydown = LydownParser.parse(load_example("#{name}.ld"),
    filename: File.join(EXAMPLES_PATH, "#{name}.ld")
  )
  work = Lydown::Work.new(opts)
  unless opts[:inhibit_end_barline].nil?
    work.context['global/settings/inhibit_end_barline'] = opts[:inhibit_end_barline]
  else
    work.context['global/settings/inhibit_end_barline'] = true
  end
  work.translate(lydown)
  ly_opts = opts.merge(no_lib: true, no_layout: !opts[:do_layout])
  work.to_lilypond(ly_opts).strip_whitespace
end

def work_from_example(name)
  Lydown::Work.new(path: File.join(EXAMPLES_PATH, name.to_s))
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
