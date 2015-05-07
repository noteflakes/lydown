require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown do
  it "correctly transforms lyrics" do
    lydown_code = LydownParser.parse(load_example('lyrics-basic.ld'))
    work = Lydown::Work.new
    work.process(lydown_code)
    ly = work.to_lilypond(stream_path: 'movements//parts/soprano/lyrics')
    expect(ly.strip_whitespace).to eq(load_example('lyrics-basic-raw.ly').strip_whitespace)
  end
  
  it "Produces the correct lilypond code" do
    verify_example('lyrics-basic')
  end
end