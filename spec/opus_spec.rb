require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Opus do
  context "with a clean context" do
    it "compiles correctly to raw" do
      lydown_code = LydownParser.parse(load_example('simple.ld'))
      opus = Lydown::Opus.new
      opus.translate(lydown_code)
      ly = opus.render(stream_path: 'movements//parts//music')
      expect(ly.strip_whitespace).to eq(load_example('simple-raw.ly'))
    end

    it "compiles correctly to lilypond document" do
      verify_example('simple')
    end
  end
end