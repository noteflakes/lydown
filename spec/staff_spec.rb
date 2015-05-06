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
end