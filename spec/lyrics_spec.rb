require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown do
  it "correctly transforms lyrics" do
    lydown_code = LydownParser.parse(load_example('lyrics-basic.ld'))
    work = Lydown::Work.new
    work.translate(lydown_code)
    ly = work.to_lilypond(stream_path: 'movements//parts/soprano/lyrics/voice1/1')
    expect(ly.strip_whitespace).to eq(load_example('lyrics-basic-raw.ly').strip_whitespace)
  end

  it "Produces the correct lyrics code" do
    verify_example('lyrics-basic')
  end

  it "Handles multiple stanzas" do
    verify_example('lyrics-multiple-stanzas')
  end

  it "Handles inline lyrics" do
    verify_example('lyrics-inline')
  end
end
