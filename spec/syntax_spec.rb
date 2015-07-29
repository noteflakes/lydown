require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown do
  it "correctly translates durations and duration syntax" do
    verify_example('durations')
  end

  it "correctly translates duration macros" do
    verify_example('duration-macros')
  end

  it "correctly translates named macros" do
    verify_example('named-macros')
  end

  it "correctly translates comments" do
    verify_example('comments')
  end

  it "correctly translates time signature settings" do
    verify_example('time-signature')
  end

  it "correctly translates time signature settings" do
    verify_example('key-signature')
  end

  it "correctly translates pickup settings" do
    verify_example('pickup')
  end

  it "correctly translate accidentals" do
    verify_example('accidentals')
  end

  it "correctly interprets accidental modes" do
    lydown = LydownParser.parse('- accidentals: blah')
    work = Lydown::Work.new
    expect {work.translate(lydown)}.to raise_error(LydownError)

    verify_example('accidental-modes')
  end

  it "correctly translate first note octave markers" do
    verify_example('octaves_first')
  end

  it "correctly translate octave markers" do
    verify_example('octaves')
  end

  it "correctly translate repeating pitch" do
    verify_example('repeating_pitch')
  end

  it "correctly translate full bar rests" do
    verify_example('full-bar-rests')
  end

  it "correctly translates clef settings" do
    verify_example('clefs')
  end

  it "correctly translates tempo settings" do
    verify_example('tempo')
  end

  it "correctly translates articulation shorthand" do
    verify_example('articulation')
  end

  it "correctly translates beaming" do
    verify_example('beams')
  end

  it "correctly translates ties" do
    verify_example('ties')
  end

  it "correctly translates slurs" do
    verify_example('slurs')
  end

  it "correctly translates inline bass figures" do
    verify_example('figures')

    verify_example('figures_bwv135')
  end

  it "correctly translates barlines" do
    verify_example('barlines')
  end

  it "correctly handles unmetered music" do
    verify_example('unmetered')
  end

  it "correctly translates tuplets" do
    verify_example('tuplets')
  end

  it "correctly translates note markup" do
    verify_example('note_markup')
  end

  it "correctly translates inline commands" do
    verify_example('commands')
  end

  it "correctly handles multiple voices" do
    verify_example('voices')
  end

  it "correctly handles chords" do
    verify_example('chords')
  end

  it "correctly handles grace notes" do
    verify_example('grace_notes')
  end
end
