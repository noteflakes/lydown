module Lydown::Rendering
  class RepeatStart < Base
    def translate
      @context.emit(:music, "\\repeat volta #{@event[:count]} { ")
    end
  end
  
  class RepeatVolta < Base
    def translate
      @context['process/volta_count'] ||= 0
      
      if @context['process/volta_count'] == 0
        @context.emit(:music, "} \\alternative { { ")
      else
        @context.emit(:music, "} { ")
      end
      @context['process/volta_count'] += 1
    end
  end
  
  class RepeatEnd < Base
    def translate
      @context['process/volta_count'] = nil
      @context.emit(:music, "} } ")
    end
  end
end