module Lydown::Parsing
  module LydownNode
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
end
