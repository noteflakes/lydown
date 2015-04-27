require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Opus do
  before(:example) do
    @opus = Lydown::Opus.new
  end
    
  it "correctly translates durations and duration syntax" do
    verify_example('durations')
  end

  it "correctly translates duration macros" do
    verify_example('duration-macros')
  end

  it "correctly translates comments" do
    verify_example('comments')
  end
    
  it "correctly translates time signature settings" do
    verify_example('time-signature')
  end

  it "correctly translates time signature settings" do
    verify_example('key-signature')
  end

  it "correctly translate accidentals" do
    verify_example('accidentals')
  end

  it "correctly translate octave markers" do
    verify_example('octaves')
  end

  it "correctly translate full bar rests" do
    verify_example('full-bar-rests')
  end

  it "correctly translates clef settings" do
    verify_example('clefs')
  end

end