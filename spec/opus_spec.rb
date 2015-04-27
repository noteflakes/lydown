require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Opus do
  context "with a clean context" do
    before(:context) do
      @source = load_example('simple.ld')
    end
    
    before(:example) do
      @opus = Lydown::Opus.new
    end
    
    it "compiles correctly to raw" do
      @opus.compile(@source)
      ly = @opus.to_lilypond(stream_path: 'movements//parts//music')
      expect(ly.strip_whitespace).to eq(load_example('simple-raw.ly'))
    end

    it "compiles correctly to lilypond document" do
      verify_example('simple')
    end
  end
end