require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Rendering::Staff do
  it "correctly orders parts in staff groups" do
    groups = Lydown::Rendering::Staff.staff_groups({}, {}, [
      'violino2', 'viola', 'violino1'
    ])
    
    expect(groups).to eq([['violino1', 'violino2'], ['viola']])

    groups = Lydown::Rendering::Staff.staff_groups({}, {}, [
      ''
    ])
    
    expect(groups).to eq([['']])
  end
  
  it "correctly generates staff hierarchy" do
    groups = Lydown::Rendering::Staff.staff_groups({}, {}, [
      'violino2', 'viola', 'violino1'
    ])
    
    hierarchy = Lydown::Rendering::Staff.staff_hierarchy(groups)
    expect(hierarchy).to eq(
    "#'(SystemStartBracket (SystemStartBrace violino1 violino2) viola )")
  end
  
  it "gives correct clef, beaming mode for different parts" do
    clef = Lydown::Rendering::Staff.clef('continuo')
    expect(clef).to eq('bass')
    
    clef = Lydown::Rendering::Staff.clef('viola')
    expect(clef).to eq('alto')
    
    mode = Lydown::Rendering::Staff.beaming_mode('violino1')
    expect(mode).to be_nil
    
    mode = Lydown::Rendering::Staff.beaming_mode('soprano')
    expect(mode).to eq('\\set Staff.autoBeaming = ##f')
  end
  
  it "passes the correct end barline when rendering staves" do
    barline = Lydown::Rendering::Staff.end_barline({'end_barline' => 'none'}, {})
    expect(barline).to be_nil

    # movement settings have precedence over work settings
    barline = Lydown::Rendering::Staff.end_barline({'end_barline' => '|:'}, {'end_barline' => '||'})
    expect(barline).to eq('||')

    # default
    barline = Lydown::Rendering::Staff.end_barline({}, {})
    expect(barline).to eq('|.')

    verify_example('end_barline')
  end
  
  it "renders smallcaps instrument name style" do
    verify_example('instrument_smallcaps_name_style', nil, mode: :score)
  end

  it "renders instrument names inline" do
    verify_example('instrument_name_inline', nil, mode: :score)
  end
end