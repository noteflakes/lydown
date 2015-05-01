require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Work do
  it "compiles correctly to raw" do
    lydown_code = LydownParser.parse(load_example('simple.ld'))
    work = Lydown::Work.new
    work.process(lydown_code)
    ly = work.to_lilypond(stream_path: 'movements//parts//music')
    expect(ly.strip_whitespace).to eq(load_example('simple-raw.ly'))
  end

  it "translates correctly to lilypond document" do
    verify_example('simple')
  end
  
  it "compiles correctly to PDF" do
    lydown_code = LydownParser.parse(load_example('simple.ld'))
    work = Lydown::Work.new
    work.process(lydown_code)
    ly = work.to_lilypond
    expect {Lydown::Lilypond.compile(ly, output_filename: 'test')}.not_to raise_error
  end

  it "handles multiple parts" do
    lydown_code = LydownParser.parse(load_example('2_part.ld'))
    work = Lydown::Work.new
    work.process(lydown_code)
    expect(work.to_lilypond(parts: 'violino1').strip_whitespace).to eq(load_example('2_part_violino1.ly', true))
    expect(work.to_lilypond(parts: 'violino2').strip_whitespace).to eq(load_example('2_part_violino2.ly', true))
  end
end