module Lydown::Rendering
  class Literal < Base
    def translate
      @context.emit(:music, "#{@event[:content]} ")
    end
  end
end
