require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Rendering::Staves do
  it "correctly orders parts in staff groups" do
    groups = Lydown::Rendering::Staves.staff_groups({}, {}, [
      'violino2', 'viola', 'violino1'
    ])
    
    expect(groups).to eq([['violino1', 'violino2'], ['viola']])

    groups = Lydown::Rendering::Staves.staff_groups({}, {}, [
      ''
    ])
    
    expect(groups).to eq([['']])
  end
  
  it "correctly generates staff hierarchy" do
    groups = Lydown::Rendering::Staves.staff_groups({}, {}, [
      'violino2', 'viola', 'violino1'
    ])
    
    hierarchy = Lydown::Rendering::Staves.staff_hierarchy(groups)
    expect(hierarchy).to eq(
    "#'(SystemStartBracket (SystemStartBrace violino1 violino2) viola )")
  end
  
  it "gives correct clef, beaming mode for different parts" do
    clef = Lydown::Rendering::Staves.clef('continuo')
    expect(clef).to eq('bass')
    
    clef = Lydown::Rendering::Staves.clef('viola')
    expect(clef).to eq('alto')
    
    mode = Lydown::Rendering::Staves.beaming_mode('violino1')
    expect(mode).to be_nil
    
    mode = Lydown::Rendering::Staves.beaming_mode('soprano')
    expect(mode).to eq('\autoBeamOff')
  end
  
  it "passes the correct end barline when rendering staves" do
    # barline = Lydown::Rendering::Staves.end_barline({'end_barline': 'none'}, {})
    # expect(barline).to be_nil
    #
    # # movement settings have precedence over work settings
    # barline = Lydown::Rendering::Staves.end_barline({'end_barline': '|:'}, {'end_barline': '||'})
    # expect(barline).to eq('||')
    #
    # # default
    # barline = Lydown::Rendering::Staves.end_barline({}, {})
    # expect(barline).to eq('|.')
    #
    # verify_example('end_barline')
  end
end