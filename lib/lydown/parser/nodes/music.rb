module Lydown::Parsing
  module Notes
    def add_note(opus, note)
      return add_macro_note(opus, note) if opus.context[:duration_macro]
    
      value = opus.context[:duration_values].first
      opus.context[:duration_values].rotate!
    
      # only add the value if different than the last used
      if value == opus.context[:last_value]
        value = ''
      else
        opus.context[:last_value] = value
      end
      
      note = Accidentals.lilypond_note_name(note, opus.context[:key])
      
      opus.emit(:music, note + value + ' ')
    end
  
    def add_macro_note(opus, note)
      opus.context[:macro_group] ||= opus.context[:duration_macro].clone
      _found = false # underscore found?

      # replace place holder and repeaters in macro group with actual note
      opus.context[:macro_group].gsub!(/[_@]/) do |match|
        if match == '_' && _found
          match
        else
          _found = true if match == '_'
          note
        end
      end
    
      unless opus.context[:macro_group].include?('_')
        # stash macro, in order to compile macro group
        macro = opus.context[:duration_macro]
        opus.context[:duration_macro] = nil

        opus.compile(opus.context[:macro_group])

        # restore macro
        opus.context[:duration_macro] = macro
        opus.context[:macro_group] = nil
      end
    end
  end
  
  LILYPOND_DURATIONS = {
    '6' => '16',
    '3' => '32'
  }

  module DurationValueNode
    
    def compile(opus)
      value = text_value.sub(/^[0-9]+/) {|m| LILYPOND_DURATIONS[m] || m}
      
      opus.context[:duration_values] = [value]
      opus.context[:duration_macro] = nil unless opus.context[:macro_group]
    end
  end
  
  module Accidentals
    KEY_CYCLE = %w{c- g- d- a- e- b- f c g d a e b f+ c+ g+ d+ a+ e+ b+}
    C_IDX = KEY_CYCLE.index('c'); A_IDX = KEY_CYCLE.index('a')
    SHARPS_IDX = KEY_CYCLE.index('f+'); FLATS_IDX = KEY_CYCLE.index('b-')
    KEY_ACCIDENTALS = {}
    
    def self.accidentals_for_key_signature(signature)
      KEY_ACCIDENTALS[signature] ||= calc_accidentals_for_key_signature(signature)
    end
    
    def self.calc_accidentals_for_key_signature(signature)
      unless signature =~ /^([a-g][\+\-]*) (major|minor)$/
        raise "Invalid key signature #{signature.inspect}"
      end

      key = $1; mode = $2
      
      # calculate offset from c major / a minor
      base_idx = (mode == 'major') ? C_IDX : A_IDX
      offset = KEY_CYCLE.index(key) - base_idx
        
      if offset >= 0
        calc_accidentals_map(KEY_CYCLE[SHARPS_IDX, offset])
      else
        calc_accidentals_map(KEY_CYCLE[FLATS_IDX + offset + 1, -offset])
      end
    end
    
    def self.calc_accidentals_map(accidentals)
      accidentals.inject({}) { |h, a| h[a[0]] = (a[1] == '+') ? 1 : -1; h}
    end
    
    def self.lilypond_note_name(note, key_signature = 'c major')
      value = 0
      # accidental value from note
      note = note.gsub(/[\-\+]/) { |c| value += (c == '+') ? 1 : -1; '' }
      # add key signature value
      value += accidentals_for_key_signature(key_signature)[note] || 0

      note + (value >= 0 ? 'is' * value : 'es' * -value)
    end
  end
  
  module NoteNode
    include Notes
    
    def compile(opus)
      add_note(opus, text_value)
    end
  end

  module RestNode
    include Notes
    
    def compile(opus)
      add_note(opus, text_value)
    end
  end
  
  module DurationMacroExpressionNode
    def compile(opus)
      opus.context[:duration_macro] = text_value
    end
  end
end
