require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Translation do
  it "translates simple ripple code to lydown" do
    ld = Lydown::Translation.process(ripple: load_example('translation_simple.rpl'))
    expect(ld).to eq(load_example('translation_simple.ld'))
  end

  it "translates named macros" do
    ld = Lydown::Translation.process(
      ripple: load_example('translation_macros.rpl'),
      macros: {'m1' => '#6. #3', 'm5' => '#4 ~ @6. #3 #6. #3'}
    )
    expect(ld).to eq(load_example('translation_macros.ld'))
  end
end