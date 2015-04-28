module Lydown::Parsing
  module LyricsNode
    def to_stream(stream)
      stream << {type: :lyrics, content: text_value}
    end
  end
end