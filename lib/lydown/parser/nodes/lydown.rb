module Lydown::Parsing
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
    def compile(opus)
      ''
    end
  end
end
