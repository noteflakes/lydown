module Lydown::Rendering
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
    
    # Takes into account the accidentals mode
    def self.translate_note_name(work, note)
      if work[:accidentals] == 'manual'
        key = 'c major'
      else
        key = work[:key]
      end
      lilypond_note_name(note, key)
    end
  end
  
  module Notes
    def add_note(work, note_info)
      return add_macro_note(work, note_info) if work['translate/duration_macro']

      work['translate/last_note_head'] = note_info[:head]

      value = work['translate/duration_values'].first
      work['translate/duration_values'].rotate!
    
      # only add the value if different than the last used
      if value == work[:last_value]
        value = ''
      else
        work[:last_value] = value
      end
      
      work.emit(:music, lilypond_note(work, note_info, value: value))
    end
    
    def lilypond_note(work, note_info, options = {})
      head = Accidentals.translate_note_name(work, note_info[:head])
      if options[:head_only]
        head
      else
        "%s%s%s%s%s%s " % [
          head, 
          note_info[:octave], 
          note_info[:accidental_flag],
          options[:value],
          lilypond_phrasing(work, note_info),
          note_info[:expressions] ? note_info[:expressions].join : ''
        ]
      end
    end
    
    def lilypond_phrasing(work, note_info)
      phrasing = ''
      if work['translate/open_beam']
        phrasing << '['
        work['translate/open_beam'] = nil
      end
      if work['translate/open_slur']
        phrasing << '('
        work['translate/open_slur'] = nil
      end
      phrasing << ']' if note_info[:beam_close]
      phrasing << ')' if note_info[:slur_close]
      phrasing
    end
  
    def add_macro_note(work, note_info)
      work['translate/macro_group'] ||= work['translate/duration_macro'].clone
      underscore_count = 0

      # replace place holder and repeaters in macro group with actual note
      work['translate/macro_group'].gsub!(/[_@]/) do |match|
        case match
        when '_'
          underscore_count += 1
          underscore_count == 1 ? note_info[:raw] : match
        when '@'
          underscore_count < 2 ? note_info[:head] : match
        end
      end

      # if group is complete, compile it just like regular code
      unless work['translate/macro_group'].include?('_')
        # stash macro, in order to compile macro group
        macro = work['translate/duration_macro']
        work['translate/duration_macro'] = nil

        code = LydownParser.parse(work['translate/macro_group'])
        work.process(code)

        # restore macro
        work['translate/duration_macro'] = macro
        work['translate/macro_group'] = nil
      end
    end
  end
  
  LILYPOND_DURATIONS = {
    '6' => '16',
    '3' => '32'
  }
  
  class Duration < Base
    def translate
      value = @event[:value].sub(/^[0-9]+/) {|m| LILYPOND_DURATIONS[m] || m}
      
      @work['translate/duration_values'] = [value]
      @work['translate/duration_macro'] = nil unless @work['translate/macro_group']
    end
  end
  
  class Note < Base
    include Notes

    def translate
      translate_expressions
      
      # look ahead and see if any beam or slur closing after note
      look_ahead_idx = @idx + 1
      while event = @stream[look_ahead_idx]
        case @stream[@idx + 1][:type]
        when :beam_close
          @event[:beam_close] = true
        when :slur_close
          @event[:slur_close] = true
        else
          break
        end
        look_ahead_idx += 1
      end
      
      add_note(@work, @event)
    end
    
    LILYPOND_EXPRESSIONS = {
      '_' => '--',
      '.' => '-.',
      '`' => '-!'
    }
    
    def translate_expressions
      return unless @event[:expressions]
      
      @event[:expressions] = @event[:expressions].map do |expr|
        if expr =~ /^\\/
          expr
        elsif LILYPOND_EXPRESSIONS[expr]
          LILYPOND_EXPRESSIONS[expr]
        else
          raise LydownError, "Invalid expression #{expr.inspect}"
        end
      end
    end
  end
  
  class BeamOpen < Base
    def translate
      @work['translate/open_beam'] = true
    end
  end
  
  class BeamClose < Base
  end
  
  class SlurOpen < Base
    def translate
      @work['translate/open_slur'] = true
    end
  end
  
  class SlurClose < Base
  end
  
  class Tie < Base
    def translate
      @work.emit(:music, '~ ')
    end
  end
  
  class ShortTie < Base
    include Notes
    
    def translate
      note_head = @work['translate/last_note_head']
      @work.emit(:music, '~ ')
      add_note(@work, {head: note_head})
    end
  end
  
  class Rest < Base
    include Notes
    
    def translate
      if @event[:multiplier]
        @event[:head] = "#{@event[:head]}#{@event[:multiplier]}*#{@work[:time]}"
      end
      
      add_note(@work, @event)
    end
  end
  
  class DurationMacro < Base
    def translate
      @work['translate/duration_macro'] = @event[:macro]
    end
  end
end