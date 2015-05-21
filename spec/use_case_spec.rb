require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown do
  it "correctly translates continuo with full bar rests" do
    verify_example('use_cases/recitativo-continuo')
  end
end

RSpec.describe Lydown do
  it "correctly handles multiple parts with multiple keys" do
    verify_example('use_cases/multi-part-multi-key')
  end
end
