require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Lydown::Rendering::Accidentals do
  Accidentals = Lydown::Rendering::Accidentals
  
  it "calculates accidental maps for major scales" do
    acc = Accidentals.accidentals_for_key_signature('c major')
    expect(acc).to eq({})

    acc = Accidentals.accidentals_for_key_signature('d major')
    expect(acc).to eq({'f' => 1, 'c' => 1})

    acc = Accidentals.accidentals_for_key_signature('b major')
    expect(acc).to eq({'f' => 1, 'c' => 1, 'g' => 1, 'd' => 1, 'a' => 1})

    acc = Accidentals.accidentals_for_key_signature('a- major')
    expect(acc).to eq({'b' => -1, 'e' => -1, 'a' => -1, 'd' => -1})

    acc = Accidentals.accidentals_for_key_signature('f+ major')
    expect(acc['e']).to eq(1)
  end

  it "calculates accidental maps for minor scales" do
    acc = Accidentals.accidentals_for_key_signature('a minor')
    expect(acc).to eq({})

    acc = Accidentals.accidentals_for_key_signature('c minor')
    expect(acc).to eq({'b' => -1, 'e' => -1, 'a' => -1})

    acc = Accidentals.accidentals_for_key_signature('b minor')
    expect(acc).to eq({'f' => 1, 'c' => 1})

    acc = Accidentals.accidentals_for_key_signature('g+ minor')
    expect(acc).to eq({'f' => 1, 'c' => 1, 'g' => 1, 'd' => 1, 'a' => 1})
  end
  
  it "translates notes according to key signature" do
    note = Accidentals.lilypond_note_name('e', 'c major')
    expect(note).to eq('e')

    note = Accidentals.lilypond_note_name('e', 'c minor')
    expect(note).to eq('ees')

    note = Accidentals.lilypond_note_name('e', 'a- major')
    expect(note).to eq('ees')

    note = Accidentals.lilypond_note_name('e', 'f+ major')
    expect(note).to eq('eis')
  end
  
  it "translates notes with accidentals according to key signature" do
    note = Accidentals.lilypond_note_name('f+', 'c major')
    expect(note).to eq('fis')

    note = Accidentals.lilypond_note_name('e+', 'c minor')
    expect(note).to eq('e')

    note = Accidentals.lilypond_note_name('e-', 'a- major')
    expect(note).to eq('eeses')

    note = Accidentals.lilypond_note_name('f+', 'f+ major')
    expect(note).to eq('fisis')
  end
end