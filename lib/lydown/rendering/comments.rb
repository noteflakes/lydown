module Lydown::Rendering
  class Comment < Base
    def translate
      @opus.emit(:music, "\n%{#{@event[:content]}%}\n")
    end
  end
end
