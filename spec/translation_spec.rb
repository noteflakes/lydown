require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')
require 'fileutils'
require 'lydown/cli'

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

  it "translates a complete directory of ripple files" do
    FileUtils.rm('spec/examples/translate/mvmt1/*.ld') rescue nil
    ld = Lydown::CLI::Translation.process(
      path: File.join('spec/examples/translate')
    )
    
    basso = IO.read('spec/examples/translate/mvmt1/basso.ld')
    violino1 = IO.read('spec/examples/translate/mvmt1/violino1.ld')
    expect(basso).to eq(load_example('translation_simple.ld'))
    expect(violino1).to eq(load_example('translation_macros.ld'))
  end
end