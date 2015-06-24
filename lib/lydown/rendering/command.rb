module Lydown::Rendering
  class Command < Base
    include Notes
    
    def translate
      if @work['process/duration_macro']
        add_macro_event(@event[:raw])
      else
        once = @event[:once] ? '\once ' : ''
        cmd = "#{once}\\#{@event[:key]} #{(@event[:arguments] || []).join(' ')} "
        @work.emit(:music, cmd)
      end
    end
  end
end
