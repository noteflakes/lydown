module Lydown::Parsing
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
  
  module Notes
    def add_note(opus, note_info)
      return add_macro_note(opus, note_info) if opus['parser/duration_macro']
    
      value = opus['parser/duration_values'].first
      opus['parser/duration_values'].rotate!
    
      # only add the value if different than the last used
      if value == opus[:last_value]
        value = ''
      else
        opus[:last_value] = value
      end
      
      opus.emit(:music, lilypond_note(opus, note_info, value: value))
    end
    
    def lilypond_note(opus, note_info, options = {})
      head = Accidentals.lilypond_note_name(note_info[:head], opus[:key])
      if options[:head_only]
        head
      else
        "%s%s%s%s " % [
          head, 
          note_info[:octave], 
          note_info[:accidental_flag], 
          options[:value]
        ]
      end
    end
  
    def add_macro_note(opus, note_info)
      opus['parser/macro_group'] ||= opus['parser/duration_macro'].clone
      underscore_count = 0

      # replace place holder and repeaters in macro group with actual note
      opus['parser/macro_group'].gsub!(/[_@]/) do |match|
        case match
        when '_'
          underscore_count += 1
          underscore_count == 1 ? note_info[:raw] : match
        when '@'
          underscore_count < 2 ? note_info[:head] : match
        end
      end

      # if group is complete, compile it just like regular code
      unless opus['parser/macro_group'].include?('_')
        # stash macro, in order to compile macro group
        macro = opus['parser/duration_macro']
        opus['parser/duration_macro'] = nil

        opus.compile(opus['parser/macro_group'])

        # restore macro
        opus['parser/duration_macro'] = macro
        opus['parser/macro_group'] = nil
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
      
      opus['parser/duration_values'] = [value]
      opus['parser/duration_macro'] = nil unless opus['parser/macro_group']
    end
  end
  
  module NoteNode
    include LydownNode
    include Notes
    
    def compile(opus)
      note_info = opus['parser/note_info'] = {'raw' => text_value}.deep!
      _compile(self, opus)
      add_note(opus, note_info)
      opus['parser/note_info'] = nil
    end
    
    module Head
      def compile(opus)
        opus['parser/note_info/head'] = text_value
      end
    end
    
    module Octave
      def compile(opus)
        opus['parser/note_info/octave'] = text_value
      end
    end
    
    module AccidentalFlag
      def compile(opus)
        opus['parser/note_info/accidental_flag'] = text_value
      end
    end
  end

  module RestNode
    include Notes
    
    def compile(opus)
      if text_value =~ /^R(\*([0-9]+))?$/
        multiplier = $2 || '1'
        value = "R#{multiplier}*#{opus[:time]}"
      else
        value = text_value
      end
        
      note_info = {'raw' => value, 'head' => value}.deep!
      add_note(opus, note_info)
    end
  end
  
  module DurationMacroExpressionNode
    def compile(opus)
      opus['parser/duration_macro'] = text_value
    end
  end
end
