require 'lydown/rendering/figures'

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
    include Lydown::Rendering::Figures

    def add_note(event)
      return add_macro_note(event) if @work['process/duration_macro']

      @work['process/last_note_head'] = event[:head]

      value = @work['process/duration_values'].first
      @work['process/duration_values'].rotate!

      add_figures(event[:figures], value) if event[:figures]

      # push value into running values accumulator. This is used to synthesize
      # the bass figures durations.
      unless event[:figures]
        @work['process/running_values'] ||= []
        if event[:rest_value]
          @work['process/running_values'] << event[:rest_value]
        else
          @work['process/running_values'] << value
        end
      end

      # only add the value if different than the last used
      if value == @work['process/last_value']
        value = ''
      else
        @work['process/last_value'] = value
      end

      @work.emit(event[:stream] || :music, lilypond_note(event, value: value))
    end

    def lilypond_note(event, options = {})
      head = Accidentals.translate_note_name(@work, event[:head])
      if options[:head_only]
        head
      else
        "%s%s%s%s%s%s " % [
          head,
          event[:octave],
          event[:accidental_flag],
          options[:value],
          lilypond_phrasing(event),
          event[:expressions] ? event[:expressions].join : ''
        ]
      end
    end

    def lilypond_phrasing(event)
      phrasing = ''
      if @work['process/open_beam']
        phrasing << '['
        @work['process/open_beam'] = nil
      end
      if @work['process/open_slur']
        phrasing << '('
        @work['process/open_slur'] = nil
      end
      phrasing << ']' if event[:beam_close]
      phrasing << ')' if event[:slur_close]
      phrasing
    end

    def lydown_phrasing_open(event)
      phrasing = ''
      if @work['process/open_beam']
        phrasing << '['
        @work['process/open_beam'] = nil
      end
      if @work['process/open_slur']
        phrasing << '('
        @work['process/open_slur'] = nil
      end
      phrasing
    end

    def lydown_phrasing_close(event)
      phrasing = ''
      phrasing << ']' if event[:beam_close]
      phrasing << ')' if event[:slur_close]
      phrasing
    end

    def add_macro_note(event)
      @work['process/macro_group'] ||= @work['process/duration_macro'].clone
      underscore_count = 0

      lydown_note = "%s%s%s%s%s%s%s" % [
        lydown_phrasing_open(event),
        event[:head], event[:octave], event[:accidental_flag],
        lydown_phrasing_close(event),
        event[:figures] ? "<#{event[:figures].join}>" : '',
        event[:expressions] ? event[:expressions].join : ''
      ]

      # replace place holder and repeaters in macro group with actual note
      @work['process/macro_group'].gsub!(/[_@]/) do |match|
        case match
        when '_'
          underscore_count += 1
          underscore_count == 1 ? lydown_note : match
        when '@'
          underscore_count < 2 ? event[:head] : match
        end
      end

      # if group is complete, compile it just like regular code
      unless @work['process/macro_group'].include?('_')
        # stash macro, in order to compile macro group
        macro = @work['process/duration_macro']
        @work['process/duration_macro'] = nil

        code = LydownParser.parse(@work['process/macro_group'])
        @work.process(code, no_reset: true)

        # restore macro
        @work['process/duration_macro'] = macro
        @work['process/macro_group'] = nil
      end
    end

    LILYPOND_EXPRESSIONS = {
      '_' => '--',
      '.' => '-.',
      '`' => '-!'
    }

    def translate_expressions
      return unless @event[:expressions]

      @event[:expressions] = @event[:expressions].map do |expr|
        if expr =~ /^(?:\\(_?))?"(.+)"$/
          placement = ($1 == '_') ? '_' : '^'
          "#{placement}\\markup { #{translate_string_expression($2)} }"
        elsif expr =~ /^\\/
          expr
        elsif LILYPOND_EXPRESSIONS[expr]
          LILYPOND_EXPRESSIONS[expr]
        else
          raise LydownError, "Invalid expression #{expr.inspect}"
        end
      end
    end

    def translate_string_expression(expr)
      expr.gsub(/__([^_]+)__/) {|m| "\\bold { #{$1} }" }.
           gsub(/_([^_]+)_/) {|m| "\\italic { #{$1} }" }
    end
  end

  LILYPOND_DURATIONS = {
    '6' => '16',
    '3' => '32'
  }

  class Duration < Base
    def translate
      # close tuplet braces
      if @work['process/tuplet_mode']
        TupletDuration.emit_tuplet_end(@work)
        @work['process/tuplet_mode'] = nil
      end

      value = @event[:value].sub(/^[0-9]+/) {|m| LILYPOND_DURATIONS[m] || m}

      if next_event && next_event[:type] == :stand_alone_figures
        @work['process/figures_duration_value'] = value
      else
        @work['process/duration_values'] = [value]
        @work['process/tuplet_mode'] = nil
        @work['process/duration_macro'] = nil unless @work['process/macro_group']
      end
    end

  end

  class TupletDuration < Base
    def self.emit_tuplet_end(work)
      work.emit(:music, '} ')
    end

    def translate
      if next_event && next_event[:type] == :stand_alone_figures
        @work['process/figures_duration_value'] = "#{@event[:value]}*#{@event[:fraction]}"
      else
        @work['process/duration_values'] = [@event[:value]]
        @work['process/last_value'] = nil
        @work['process/tuplet_mode'] = true

        group_value = @event[:value].to_i / @event[:group_length].to_i
        @work.emit(:music, "\\tuplet #{@event[:fraction]} #{group_value} { ")
      end
    end
  end

  class Note < Base
    include Notes

    def translate
      translate_expressions

      # look ahead and see if any beam or slur closing after note
      look_ahead_idx = @idx + 1
      while event = @stream[look_ahead_idx]
        case event[:type]
        when :beam_close
          @event[:beam_close] = true
        when :slur_close
          @event[:slur_close] = true
        else
          break
        end
        look_ahead_idx += 1
      end

      add_note(@event)
    end
  end

  class StandAloneFigures < Base
    include Notes

    def translate
      add_stand_alone_figures(@event[:figures])
    end
  end

  class BeamOpen < Base
    def translate
      @work['process/open_beam'] = true
    end
  end

  class BeamClose < Base
    def translate
    end
  end

  class SlurOpen < Base
    def translate
      @work['process/open_slur'] = true
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
      note_head = @work['process/last_note_head']
      @work.emit(:music, '~ ')
      add_note({head: note_head})
    end
  end

  class Rest < Base
    include Notes

    def full_bar_value(time)
      r = Rational(time)
      case r.numerator
      when 1
        r.denominator.to_s
      when 3
        "#{r.denominator / 2}."
      else
        nil
      end
    end

    def translate
      translate_expressions

      if @event[:multiplier]
        value = full_bar_value(@work[:time])
        if value
          @event[:rest_value] = "#{value}*#{@event[:multiplier]}"
          @event[:head] = "#{@event[:head]}#{@event[:rest_value]}"
        else
          @event[:head] = "#{@event[:head]}#{@event[:multiplier]}*#{@work[:time]}"
        end
        # reset the last value so the next note will be rendered with its value
        @work['process/last_value'] = nil
        @work['process/duration_values'] = []
      end

      add_note(@event)
    end
  end

  class Silence < Base
    include Notes

    def translate
      add_note(@event)
    end
  end

  class FiguresSilence < Base
    include Notes

    def translate
      @event[:stream] = :figures
      add_note(@event)
    end
  end

  class DurationMacro < Base
    def translate
      if @event[:macro] =~ /^[a-zA-Z_]/
        macro = @work['macros'][@event[:macro]]
        if macro
          if macro =~ /^\{(.+)\}$/
            macro = $1
          end
          @work['process/duration_macro'] = macro
        else
          raise LydownError, "Unknown macro #{@event[:macro]}"
        end
      else
        @work['process/duration_macro'] = @event[:macro]
      end
    end
  end

  class Barline < Base
    def translate
      barline = @event[:barline]
      barline = '' if barline == '?|'
      @work.emit(:music, "\\bar \"#{barline}\" ")
    end
  end
end
