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
end