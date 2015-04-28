module Lydown::Parsing
  module CommentContentNode
    def to_stream(stream)
      stream << {type: :comment, content: text_value.strip}
    end
  end
end
