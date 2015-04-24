require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Opus do
  context "with a clean context" do
    before(:example) do
      @opus = Lydown::Opus.new
    end
    
    it "correctly translates durations and duration syntax" do
      @opus.compile(load_example('example-durations.ld'))
      ly = @opus.to_lilypond.strip_whitespace
      expect(ly).to eq(load_example('example-durations.ly'))
    end

    it "correctly translates duration macros" do
      @opus.compile(load_example('example-duration-macros.ld'))
      ly = @opus.to_lilypond.strip_whitespace
      expect(ly).to eq(load_example('example-duration-macros.ly'))
    end
  end
end