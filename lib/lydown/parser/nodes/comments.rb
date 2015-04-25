module Lydown::Parsing
  module CommentContentNode
    def compile(opus)
      opus.emit(:music, "\n%{#{text_value.strip}}\n")
    end
  end
end
