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

RSpec.describe "Lydown::WorkContext#colla_parte_map" do
  it "returns an empty hash by default" do
    work = Lydown::Work.new

    map = work.context.colla_parte_map(nil)
    expect(map).to eq({})
  end

  it "correctly parses part source settings" do
    work = work_from_example(:settings_part_source)

    map = work.context.colla_parte_map(nil)
    expect(map).to eq({
      'soprano' => ['violino1', 'violino2'],
      'continuo' => ['violoncello']
    })
  end

  it "correctly parses colla parte settings" do
    work = work_from_example(:settings_colla_parte)

    map = work.context.colla_parte_map(nil)
    expect(map).to eq({
      'alto' => ['violino2', 'oboe2'],
      'continuo' => ['violoncello']
    })
  end
  
  it "removes any duplicates in colla parte, part source settings" do
    work = work_from_example(:settings_colla_parte_source)

    map = work.context.colla_parte_map(nil)
    expect(map).to eq({
      'soprano' => ['violino1'],
      'alto' => ['violino2', 'oboe2'],
      'continuo' => ['violone', 'violoncello']
    })
  end
  
  it "it renders according to \\mode commands and render mode" do
    verify_example(:mode, :mode_score, mode: :score)

    verify_example(:mode, :mode_part, mode: :part, parts: 'viola')
  end
end
