module Lydown::Rendering
  class Comment < Base
    def translate
      @context.emit(:music, "\n%{#{@event[:content]}%}\n")
    end
  end
end
