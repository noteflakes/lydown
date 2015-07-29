require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe LydownParser do
  it "parses to event stream" do
    parser = LydownParser.new
    ast = parser.parse(load_example('simple.ld'))
    stream = ast.to_stream
    expect(stream).to be_a(Array)
    expect(stream[0]).to eq({type: :duration, value: '4'})
    expect(stream[1]).to eq({type: :note, raw: 'c', head: 'c'})
    expect(stream[2]).to eq({type: :duration, value: '8'})
    expect(stream[3]).to eq({type: :note, raw: 'e', head: 'e'})
    expect(stream[4]).to eq({type: :note, raw: 'g', head: 'g'})
    expect(stream[5]).to eq({type: :duration, value: '2'})
    expect(stream[6]).to eq({type: :note, raw: 'c', head: 'c'})
  end
  
  it "parses to event stream using .parse class method" do
    stream = LydownParser.parse(load_example('simple.ld'))
    expect(stream).to be_a(Array)
    expect(stream[0]).to eq({type: :duration, value: '4'})
    expect(stream[1]).to eq({type: :note, raw: 'c', head: 'c'})
    expect(stream[2]).to eq({type: :duration, value: '8'})
    expect(stream[3]).to eq({type: :note, raw: 'e', head: 'e'})
    expect(stream[4]).to eq({type: :note, raw: 'g', head: 'g'})
    expect(stream[5]).to eq({type: :duration, value: '2'})
    expect(stream[6]).to eq({type: :note, raw: 'c', head: 'c'})
  end
  
  it "includes source position in note events in proof mode" do
    filename = 'simple.ld'
    source = load_example(filename)
    
    stream = LydownParser.parse(source, {
      filename: filename,
      source: source,
      proof_mode: true
    })

    expect(stream[0]).to eq({type: :source_ref, filename: filename, 
      source: source, proof_mode: true})
    expect(stream[1]).to eq({type: :duration, value: '4', 
      filename: filename, source: source, line: 1, column: 1})
    expect(stream[2]).to eq({type: :note, raw: 'c', 
      filename: filename, source: source, line: 1, column: 2, head: 'c'})
    expect(stream[3]).to eq({type: :duration, value: '8',
      filename: filename, source: source, line: 1, column: 4})
    expect(stream[4]).to eq({type: :note, raw: 'e', 
      filename: filename, source: source, line: 1, column: 5, head: 'e'})
    expect(stream[5]).to eq({type: :note, raw: 'g',
      filename: filename, source: source, line: 1, column: 6, head: 'g'})
    expect(stream[6]).to eq({type: :duration, value: '2',
      filename: filename, source: source, line: 1, column: 8})
    expect(stream[7]).to eq({type: :note, raw: 'c',
      filename: filename, source: source, line: 1, column: 9, head: 'c'})
  end
  
  it "inserts point-and-click links in proof mode" do
    filename = 'simple_macro.ld'
    source = load_example(filename)
    
    stream = LydownParser.parse(source, {
      filename: filename,
      source: source,
      proof_mode: true
    })
    
    full_filename = File.expand_path(filename)

    expect(stream[0]).to eq({type: :source_ref, filename: filename, 
      source: source, proof_mode: true})
    expect(stream[1]).to eq({type: :duration_macro, macro: '4_8__',
      filename: filename, source: source, line: 1, column: 2})
    expect(stream[2]).to eq({type: :note, raw: 'c', 
      filename: filename, source: source, line: 1, column: 8, head: 'c'})
    expect(stream[3]).to eq({type: :note, raw: 'e', 
      filename: filename, source: source, line: 1, column: 9, head: 'e'})
    expect(stream[4]).to eq({type: :note, raw: 'g',
      filename: filename, source: source, line: 1, column: 10, head: 'g'})
    expect(stream[5]).to eq({type: :note, raw: 'c', 
      filename: filename, source: source, line: 1, column: 11, head: 'c'})
    expect(stream[6]).to eq({type: :note, raw: 'g', 
      filename: filename, source: source, line: 1, column: 12, head: 'g'})
    expect(stream[7]).to eq({type: :note, raw: 'e',
      filename: filename, source: source, line: 1, column: 13, head: 'e'})
      
    work = Lydown::Work.new
    work.context['end_barline'] = 'none'
    # turn on proof mode in order to emit source refs
    work.context['options'][:proof_mode] = true
    work.translate(stream)
    
    link_pre = "\\once \\override NoteHead.after-line-breaking =\n            #(add-link \"txmt://open?url=file:///Users/sharon/repo/lydown/simple_macro.ld&line=%d&column=%d\")"
    
    expect(work.context['movements//parts//music']).to eq(
      "#{link_pre % [1, 8]} c4 #{link_pre % [1, 9]} e8 #{link_pre % [1, 10]} g #{link_pre % [1, 11]} c4 #{link_pre % [1, 12]} g8 #{link_pre % [1, 13]} e #{link_pre % [1, 15]} c1 "
    )
  end
  
  it "ignores whitespace at beginning of line" do
    stream = LydownParser.parse('  a')
    expect(stream).to eq([{type: :note, raw: 'a', head: 'a'}])
  end
  
  it "correctly handles stream switching" do
    verify_example('streams')
    verify_example('streams_multipart', nil, mode: :score)
  end
end