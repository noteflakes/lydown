module Lydown::Parsing
  module Root
    def _to_stream(element, stream)
      if element.elements
        element.elements.each do |e|
          e.respond_to?(:to_stream) ? e.to_stream(stream) : _to_stream(e, stream)
        end
      end
      stream
    end

    def to_stream(stream = [])
      _to_stream(self, stream)
      stream
    end
  end

  module CommentContent
    def to_stream(stream)
      stream << {type: :comment, content: text_value.strip}
    end
  end

  module Setting
    include Root

    def to_stream(stream)
      @setting = {type: :setting}
      _to_stream(self, stream)
    end

    def setting
      @setting
    end

    def emit_setting(stream)
      stream << @setting
    end

    module Key
      def to_stream(stream)
        parent.setting[:key] = text_value
      end
    end

    module Value
      def to_stream(stream)
        parent.setting[:value] = text_value.strip
        parent.emit_setting(stream)
      end
    end
  end

  module DurationValue
    def to_stream(stream)
      stream << {type: :duration, value: text_value}
    end
  end

  module Note
    include Root

    def to_stream(stream)
      note = {type: :note, raw: text_value}
      _to_stream(self, note)
      stream << note
    end

    module Head
      def to_stream(note)
        note[:head] = text_value
      end
    end

    module Octave
      def to_stream(note)
        note[:octave] = text_value
      end
    end

    module AccidentalFlag
      def to_stream(note)
        note[:accidental_flag] = text_value
      end
    end

    module Expression
      def to_stream(note)
        note[:expressions] ||= []
        note[:expressions] << text_value
      end
    end
  end

  module FiguresComponent
    def to_stream(note)
      note[:figures] ||= []
      note[:figures] << text_value
    end
  end

  module StandAloneFigures
    include Root

    def to_stream(stream)
      note = {type: :stand_alone_figures}
      _to_stream(self, note)
      stream << note
    end
  end

  module Phrasing
    module BeamOpen
      def to_stream(stream)
        stream << {type: :beam_open}
      end
    end

    module BeamClose
      def to_stream(stream)
        stream << {type: :beam_close}
      end
    end

    module SlurOpen
      def to_stream(stream)
        stream << {type: :slur_open}
      end
    end

    module SlurClose
      def to_stream(stream)
        stream << {type: :slur_close}
      end
    end
  end

  module Tie
    def to_stream(stream)
      stream << {type: :tie}
    end
  end

  module ShortTie
    def to_stream(stream)
      stream << {type: :short_tie}
    end
  end

  module Rest
    def to_stream(stream)
      rest = {type: :rest, raw: text_value, head: text_value[0]}
      if text_value =~ /^R(\*([0-9]+))?$/
        rest[:multiplier] = $2 || '1'
      end

      stream << rest
    end
  end

  module Silence
    def to_stream(stream)
      stream << {type: :silence, raw: text_value, head: text_value[0]}
    end
  end

  module DurationMacroExpression
    def to_stream(stream)
      stream << {type: :duration_macro, macro: text_value}
    end
  end

  module Lyrics
    def to_stream(stream)
      stream << {type: :lyrics, content: text_value}
    end
  end

  module Barline
    def to_stream(stream)
      stream << {type: :barline, barline: text_value}
    end
  end
end
