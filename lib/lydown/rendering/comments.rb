module Lydown::Rendering
  class Comment < Base
    def translate
      @work.emit(:music, "\n%{#{@event[:content]}%}\n")
    end
  end
end
