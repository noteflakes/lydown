require 'lydown/rendering/figures'
require 'lydown/rendering/notes'

module Lydown::Rendering
  LILYPOND_DURATIONS = {
    '6' => '16',
    '3' => '32'
  }

  class Duration < Base
    def translate
      Notes.cleanup_duration_macro(@work)

      # close tuplet braces
      if @work['process/tuplet_mode']
        TupletDuration.emit_tuplet_end(@work)
        @work['process/tuplet_mode'] = nil
      end

      if @work['process/grace_mode']
        Grace.emit_grace_end(@work)
        @work['process/grace_mode'] = nil
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
      Notes.cleanup_duration_macro(@work)

      # close tuplet braces
      if @work['process/tuplet_mode']
        TupletDuration.emit_tuplet_end(@work)
        @work['process/tuplet_mode'] = nil
      end

      if next_event && next_event[:type] == :stand_alone_figures
        @work['process/figures_duration_value'] = "#{@event[:value]}*#{@event[:fraction]}"
      else
        value = LILYPOND_DURATIONS[@event[:value]] || @event[:value]

        @work['process/duration_values'] = [value]
        @work['process/last_value'] = nil
        @work['process/tuplet_mode'] = true
        
        group_value = value.to_i / @event[:group_length].to_i
        @work.emit(:music, "\\tuplet #{@event[:fraction]} #{group_value} { ")
      end
    end
  end
  
  class Grace < Base
    def self.emit_grace_end(work)
      work.emit(:music, '} ')
    end
    
    def translate
      # close tuplet braces
      if @work['process/grace_mode']
        Grace.emit_grace_end(@work)
        @work['process/grace_mode'] = nil
      end

      value = LILYPOND_DURATIONS[@event[:value]] || @event[:value]

      @work['process/duration_values'] = [value]
      @work['process/last_value'] = nil
      @work['process/grace_mode'] = true
      
      @work.emit(:music, "\\#{@event[:kind]} { ")
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
  
  class Chord < Base
    include Notes
    
    def translate
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
      
      add_chord(@event)
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
        @work['process/duration_macro'] = nil unless @work['process/macro_group']
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
      Notes.cleanup_duration_macro(@work)
      
      if @event[:macro] =~ /^[a-zA-Z_]/
        macro = @work['macros'][@event[:macro]]
        if macro
          if macro =~ /^\{(.+)\}$/
            macro = $1
          end
          # replace the repeating note placeholder with another sign in order to
          # avoid mixing up with repeating notes from outside the macro
          @work['process/duration_macro'] = macro.gsub('@', '∞')
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
