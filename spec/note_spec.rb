require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Rendering::Octaves do
  
  it "calculates octave markers for first note" do
    o = Lydown::Rendering::Octaves

    expect(o.relative_octave('c', 'c')).to eq('')
    expect(o.relative_octave("c'", 'c')).to eq("'")
    expect(o.relative_octave("g'", 'c')).to eq("''")
    expect(o.relative_octave("a,", 'c')).to eq("")

    expect(o.relative_octave("e-'", 'c')).to eq("'")
    expect(o.relative_octave("f+'", 'c')).to eq("'")

    expect(o.relative_octave("f+'", "c'")).to eq("")

    expect(o.relative_octave("a,", "c,")).to eq("'")

    expect(o.relative_octave("f,", "c,")).to eq("")

    expect(o.relative_octave("f,,", "c,")).to eq(",")
  end
end
