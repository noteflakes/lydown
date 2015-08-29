require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe "Lydown::WorkContext#get_setting" do
  it "returns defaults settings" do
    work = Lydown::Work.new

    clef = work.context.get_setting('clef', part: 'gamba1')
    expect(clef).to eq('alto')
  end
  
  it "returns overriden settings" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'settings_clef'))
    clef = work.context.get_setting('clef', part: 'gamba1')
    expect(clef).to eq('bass')
  end
  
  it "returns overriden settings in parts section" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'settings_parts_clef'))
    clef = work.context.get_setting('clef', part: 'gamba1')
    expect(clef).to eq('bass')
  end
    
end
