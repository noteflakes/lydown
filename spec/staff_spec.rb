require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Rendering::Staff do
  it "correctly orders parts in staff groups" do
    context = Lydown::WorkContext.new
    
    groups = Lydown::Rendering::Staff.staff_groups(context, {}, [
      'violino2', 'viola', 'violino1'
    ])
    
    expect(groups).to eq([['violino1', 'violino2'], ['viola']])

    groups = Lydown::Rendering::Staff.staff_groups(context, {}, [
      ''
    ])
    
    expect(groups).to eq([['']])
  end
  
  it "correctly generates staff hierarchy" do
    context = Lydown::WorkContext.new
    
    groups = Lydown::Rendering::Staff.staff_groups(context, {}, [
      'violino2', 'viola', 'violino1'
    ])
    
    hierarchy = Lydown::Rendering::Staff.staff_hierarchy(groups)
    expect(hierarchy).to eq(
    "#'(SystemStartBar (SystemStartBrace violino1 violino2) viola )")
  end
  
  it "gives correct clef, beaming mode for different parts" do
    context = Lydown::WorkContext.new
    
    clef = Lydown::Rendering::Staff.clef(context, part: 'continuo')
    expect(clef).to eq('bass')
    
    clef = Lydown::Rendering::Staff.clef(context, part: 'viola')
    expect(clef).to eq('alto')
    
    mode = Lydown::Rendering::Staff.beaming_mode(context, part: 'violino1')
    expect(mode).to be_nil
    
    mode = Lydown::Rendering::Staff.beaming_mode(context, part: 'soprano')
    expect(mode).to eq('\\set Staff.autoBeaming = ##f')
  end
  
  it "passes the correct end barline when rendering staves" do
    context = Lydown::WorkContext.new
    context.set_setting('end_barline', 'none')
    barline = Lydown::Rendering::Staff.end_barline(context, {})
    expect(barline).to be_nil

    # movement settings have precedence over work settings
    context.set_setting('end_barline', '|:')
    context[:movement] = '01-intro'
    context.set_setting('end_barline', '||')
    barline = Lydown::Rendering::Staff.end_barline(context, {})
    expect(barline).to eq('|:')
    barline = Lydown::Rendering::Staff.end_barline(context, movement: '01-intro')
    expect(barline).to eq('||')

    # default
    context = Lydown::WorkContext.new
    barline = Lydown::Rendering::Staff.end_barline(context, {})
    expect(barline).to eq('|.')

    verify_example('end_barline', nil, inhibit_end_barline: false)
  end
  
  it "renders smallcaps instrument name style" do
    verify_example('instrument_smallcaps_name_style', nil, mode: :score)
  end

  it "renders instrument names inline" do
    verify_example('instrument_name_inline', nil, mode: :score)
  end
end