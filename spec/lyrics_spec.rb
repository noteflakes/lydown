require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Opus do
  it "correctly transforms lyrics" do
    lydown_code = LydownParser.parse(load_example('lyrics-basic.ld'))
    opus = Lydown::Opus.new
    opus.translate(lydown_code)
    ly = opus.render(stream_path: 'movements//parts//lyrics')
    expect(ly.strip_whitespace).to eq(load_example('lyrics-basic-raw.ly').strip_whitespace)
  end
end