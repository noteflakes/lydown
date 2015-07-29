require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Work do
  it "compiles correctly to raw" do
    lydown_code = LydownParser.parse(load_example('simple.ld'))
    work = Lydown::Work.new
    work.translate(lydown_code)
    ly = work.to_lilypond(stream_path: 'movements//parts//music')
    expect(ly.strip_whitespace).to eq(load_example('simple-raw.ly'))
  end

  it "translates correctly to lilypond document" do
    verify_example('simple')
  end
  
  it "compiles correctly to PDF" do
    lydown_code = LydownParser.parse(load_example('simple.ld'))
    work = Lydown::Work.new
    work.translate(lydown_code)
    ly = work.to_lilypond(no_lib: true)
    expect {Lydown::Lilypond.compile(ly, output_filename: 'spec/tmp/test')}.not_to raise_error
  end

  it "handles multiple parts" do
    lydown_code = LydownParser.parse(load_example('2_part.ld'))
    work = Lydown::Work.new
    work.translate(lydown_code)
    work.context['end_barline'] = 'none'
    
    ly = work.to_lilypond(parts: 'violino1', mode: :part, no_lib: true).strip_whitespace
    ex = load_example('2_part_violino1.ly', strip: true)
    expect(ly).to eq(ex)
    
    ly = work.to_lilypond(parts: 'violino2', mode: :part, no_lib: true).strip_whitespace
    ex = load_example('2_part_violino2.ly', strip: true)
    expect(ly).to eq(ex)
  end
  
  it "handles multiple part scores" do
    verify_example('2_part', nil, mode: :score)
    verify_example('part_settings', nil, mode: :score)
  end
  
  it "processes files if given path" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'simple'))
    work.context['end_barline'] = 'none'
    
    ly = work.to_lilypond(mode: :part, no_lib: true).strip_whitespace
    ex = load_example('simple.ly', strip: true)
    expect(ly).to eq(ex)
  end
  
  it "handles multipart directories" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'multipart'))
    work.context['end_barline'] = 'none'
    
    ly = work.to_lilypond(parts: 'violino1', mode: :part, no_lib: true).strip_whitespace
    ex = load_example('multipart_violino1.ly', strip: true)
    expect(ly).to eq(ex)
    
    ly = work.to_lilypond(parts: 'violino2', mode: :part, no_lib: true).strip_whitespace
    ex = load_example('multipart_violino2.ly', strip: true)
    expect(ly).to eq(ex)

    ly = work.to_lilypond(mode: :score, no_lib: true).strip_whitespace
    ex = load_example('multipart_score.ly', strip: true)
    expect(ly).to eq(ex)
  end
  
  it "handles multiple movements" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, '2_movement.ld'))
    work.context['end_barline'] = 'none'
    
    ly = work.to_lilypond(movements: '01-intro', no_lib: true).strip_whitespace
    ex = load_example('2_movement_intro.ly', strip: true)
    expect(ly).to eq(ex)
    
    ly = work.to_lilypond(movements: '02-outro', mode: :part, no_lib: true).strip_whitespace
    ex = load_example('2_movement_outro.ly', strip: true)
    expect(ly).to eq(ex)

    ly = work.to_lilypond(mode: :part, no_lib: true).strip_whitespace
    ex = load_example('2_movement.ly', strip: true)
    expect(ly).to eq(ex)
  end
  
  it "handles work with multiple movements, parts" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'fullwork'))
    
    ly = work.to_lilypond(mode: :score, no_lib: true).strip_whitespace
    ex = load_example('fullwork.ly', strip: true)
    expect(ly).to eq(ex)

    ly = work.to_lilypond(movements: '01-intro', mode: :score, no_lib: true).strip_whitespace
    ex = load_example('fullwork_intro.ly', strip: true)
    expect(ly).to eq(ex)

    ly = work.to_lilypond(movements: '02-outro', mode: :score, no_lib: true).strip_whitespace
    ex = load_example('fullwork_outro.ly', strip: true)
    expect(ly).to eq(ex)

    ly = work.to_lilypond(movements: '01-intro', parts: 'violino1', no_lib: true).strip_whitespace
    ex = load_example('fullwork_intro_violino1.ly', strip: true)
    expect(ly).to eq(ex)
    
    ly = work.to_lilypond(parts: 'violino2', no_lib: true).strip_whitespace
    ex = load_example('fullwork_violino2.ly', strip: true)
    expect(ly).to eq(ex)
    
    ly = work.to_lilypond(parts: 'violoncello', no_lib: true).strip_whitespace
    ex = load_example('fullwork_violoncello.ly', strip: true)
    expect(ly).to eq(ex)
  end
   
  it "handles empty staves setting" do
    verify_example('empty_staves', nil, mode: :score)
  end
  
  it "preserves common settings (work, movement files) between parts and movements" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'fullwork_settings'))
    
    ly = work.to_lilypond(mode: :score, no_lib: true).strip_whitespace
    ex = load_example('fullwork_settings.ly', strip: true)
    expect(ly).to eq(ex)

  end

  it "adds the lydown library include file to the rendered file" do
    work = Lydown::Work.new(path: File.join(EXAMPLES_PATH, 'simple'))
    
    ly = work.to_lilypond.strip_whitespace.gsub(LY_LIB_DIR, 'lydown')
    ex = load_example('simple_include_lib.ly', strip: true)
    expect(ly).to eq(ex)
  end
end