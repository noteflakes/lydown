module Lydown::Translation::Ripple
  class Root < Treetop::Runtime::SyntaxNode
    def _translate(element, stream, opts)
      if element.elements
        element.elements.each do |e|
          e.respond_to?(:translate) ? 
            e.translate(stream, opts) : 
            _translate(e, stream, opts)
        end
      end
      stream
    end

    def translate(stream = [], opts = {})
      _translate(self, stream, opts)
      stream
    end
    
    def source_line(opts)
      if opts[:source]
        line, column = opts[:source].find_line_and_column(interval.first)
        line
      else
        nil
      end
    end
    
    def check_line_break(stream, opts)
      line = source_line(opts)
      if line != opts[:last_line]
        unless stream.empty? || (stream[-1] == "\n")
          # remove whitespace at end of line
          stream.gsub!(/\s+$/, '')
          stream << "\n"
        end
        opts[:last_line] = line
      end
    end
  end
  
  class RelativeCommand  < Root
    def translate(stream, opts)
      opts[:relative_start_octave] = text_value
    end
  end
  
  class Note < Root
    def translate(stream, opts)
      check_line_break(stream, opts)
      note = {expressions: []}
      _translate(self, note, opts)
      stream << "%s%s%s" % [
        note[:duration],
        note[:head],
        note[:expressions].join
      ]
    end
    
    class Head < Root
      def translate(note, opts)
        head = text_value.gsub('es', '-').gsub('s', '+')
        head.sub!(/([a-g][\+\-]*)/) do |m|
          Lydown::Rendering::Accidentals.chromatic_to_diatonic(
            m, opts[:key] || 'c major'
          )
        end
        note[:head] = head
      end
    end
    
    class Duration < Root
      def translate(note, opts)
        note[:duration] = text_value
      end
    end
    
    class Expression < Root
      def translate(note, opts)
        note[:expressions] << text_value
      end
    end
  end
  
  class KeySignature < Root
    def translate(stream, opts)
      signature = {}
      _translate(self, signature, opts)
      opts[:key] = "#{signature[:head]} #{signature[:mode]}"
      stream << "- key: #{opts[:key]}\n"
    end
    
    class Mode < Root
      def translate(signature, opts)
        if text_value =~ /(major|minor)/
          signature[:mode] = $1
        end
      end
    end
  end
  
  class TimeSignature < Root
    def translate(stream, opts)
      opts[:time] = text_value
      stream << "- time: #{text_value}\n"
    end
  end
  
  class FullRest < Root
    def translate(stream, opts)
      check_line_break(stream, opts)
      if text_value =~ /R[\d]+\*(\d+)/
        stream << "R*#{$1} "
      else
        stream << "R "
      end
    end
  end
  
  class Phrasing < Root
    def translate(stream, opts)
      check_line_break(stream, opts)
      stream << text_value
    end
  end
end