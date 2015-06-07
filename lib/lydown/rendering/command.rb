module Lydown::Rendering
  class Command < Base
    def translate
      once = @event[:once] ? '\once ' : ''
      
      cmd = "#{once}\\#{@event[:key]} #{(@event[:arguments] || []).join(' ')} "
      @work.emit(:music, cmd)
    end
  end
end
