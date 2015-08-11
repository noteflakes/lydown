require 'lydown/rendering/figures'
require 'lydown/rendering/notes'

module Lydown::Rendering
  LILYPOND_DURATIONS = {
    '6' => '16',
    '3' => '32'
  }

  class Duration < Base
    def translate
      Notes.cleanup_duration_macro(@context)

      # close tuplet braces
      if @context['process/tuplet_mode']
        TupletDuration.emit_tuplet_end(@context)
        @context['process/tuplet_mode'] = nil
      end

      if @context['process/grace_mode']
        Grace.emit_grace_end(@context)
        @context['process/grace_mode'] = nil
      end

      value = @event[:value].sub(/^[0-9]+/) {|m| LILYPOND_DURATIONS[m] || m}

      if next_event && next_event[:type] == :stand_alone_figures
        @context['process/figures_duration_value'] = value
      else
        @context['process/duration_values'] = [value]
        @context['process/tuplet_mode'] = nil
        @context['process/duration_macro'] = nil unless @context['process/macro_group']
      end
    end

  end

  class TupletDuration < Base
    def self.emit_tuplet_end(context)
      context.emit(:music, '} ')
    end

    def translate
      Notes.cleanup_duration_macro(@context)

      # close tuplet braces
      if @context['process/tuplet_mode']
        TupletDuration.emit_tuplet_end(@context)
        @context['process/tuplet_mode'] = nil
      end

      if next_event && next_event[:type] == :stand_alone_figures
        @context['process/figures_duration_value'] = "#{@event[:value]}*#{@event[:fraction]}"
      else
        value = LILYPOND_DURATIONS[@event[:value]] || @event[:value]

        @context['process/duration_values'] = [value]
        @context['process/last_value'] = nil
        @context['process/tuplet_mode'] = true
        
        group_value = value.to_i / @event[:group_length].to_i
        @context.emit(:music, "\\tuplet #{@event[:fraction]} #{group_value} { ")
      end
    end
  end
  
  class Grace < Base
    def self.emit_grace_end(context)
      context.emit(:music, '} ')
    end
    
    def translate
      # close tuplet braces
      if @context['process/grace_mode']
        Grace.emit_grace_end(@context)
        @context['process/grace_mode'] = nil
      end

      value = LILYPOND_DURATIONS[@event[:value]] || @event[:value]

      @context['process/duration_values'] = [value]
      @context['process/last_value'] = nil
      @context['process/grace_mode'] = true
      
      @context.emit(:music, "\\#{@event[:kind]} { ")
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
      translate_expressions
      
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
      @context['process/open_beam'] = true
    end
  end

  class BeamClose < Base
    def translate
    end
  end

  class SlurOpen < Base
    def translate
      @context['process/open_slur'] = true
    end
  end

  class SlurClose < Base
  end

  class Tie < Base
    def translate
      @context.emit(:music, '~ ')
    end
  end

  class ShortTie < Base
    include Notes

    def translate
      note_head = @context['process/last_note_head']
      @context.emit(:music, '~ ')
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
        value = full_bar_value(@context[:time])
        @context['process/duration_macro'] = nil unless @context['process/macro_group']
        if value
          @event[:rest_value] = "#{value}*#{@event[:multiplier]}"
          @event[:head] = "#{@event[:head]}#{@event[:rest_value]}"
        else
          @event[:head] = "#{@event[:head]}#{@event[:multiplier]}*#{@context[:time]}"
        end
        # reset the last value so the next note will be rendered with its value
        @context['process/last_value'] = nil
        @context['process/duration_values'] = []
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
      Notes.cleanup_duration_macro(@context)
      
      if @event[:macro] =~ /^[a-zA-Z_]/
        macro = @context['macros'][@event[:macro]]
        if macro
          if macro =~ /^\{(.+)\}$/
            macro = $1
          end
          # replace the repeating note placeholder with another sign in order to
          # avoid mixing up with repeating notes from outside the macro
          @context['process/duration_macro'] = macro.gsub('@', '∞')
        else
          raise LydownError, "Unknown macro #{@event[:macro]}"
        end
      else
        @context['process/duration_macro'] = @event[:macro]
      end
    end
  end

  class Barline < Base
    def translate
      barline = @event[:barline]
      barline = '' if barline == '?|'
      @context.emit(:music, "\\bar \"#{barline}\" ")
    end
  end
end
