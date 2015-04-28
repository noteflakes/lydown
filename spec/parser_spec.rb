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
end