require 'rubygems'
require 'treetop'

module Lydown
  module Parsing
    module LydownNode
      def _compile(element, opus)
        if element.elements
          element.elements.each do |e|
            e.respond_to?(:compile) ? e.compile(opus) : _compile(e, opus)
          end
        end    
      end
  
      def compile(opus)
        _compile(self, opus)
      end
    end

    module NullNode
      def compile(ctx = {})
        ''
      end
    end

    LILYPOND_DURATIONS = {
      '6' => '16',
      '3' => '32'
    }

    module DurationValueNode
      
      def compile(opus)
        opus.context[:duration_values] = 
          [LILYPOND_DURATIONS[text_value] || text_value]
      end
    end

    module NoteNode
      def compile(opus)
        opus.add_note(text_value)
      end
    end

    module RestNode
      def compile(opus)
        opus.add_note(text_value)
      end
    end
  end
end

include Lydown::Parsing

Treetop.load './lib/lydown/lydown'