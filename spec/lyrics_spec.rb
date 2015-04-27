require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Opus do
  it "correctly transforms lyrics" do
    opus = Lydown::Opus.new
    opus.compile(load_example('lyrics-basic.ld'))
    ly = opus.to_lilypond(stream_path: 'movements//parts//lyrics')
    expect(ly.strip_whitespace).to eq(load_example('lyrics-basic-raw.ly').strip_whitespace)
  end
end