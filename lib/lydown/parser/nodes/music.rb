module Lydown::Parsing
  module DurationValueNode
    
    def to_stream(stream)
      stream << {type: :duration, value: text_value}
    end
  end
  
  module NoteNode
    include LydownNode
    
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
  end

  module RestNode
    def to_stream(stream)
      rest = {type: :rest, raw: text_value, head: text_value[0]}
      if text_value =~ /^R(\*([0-9]+))?$/
        rest[:multiplier] = $2 || '1'
      end
        
      stream << rest
    end
  end
  
  module DurationMacroExpressionNode
    def to_stream(stream)
      stream << {type: :duration_macro, macro: text_value}
    end
  end
end
