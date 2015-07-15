module Lydown::Rendering
  class Command < Base
    include Notes
    
    def translate
      if @work['process/duration_macro']
        add_macro_event(@event[:raw] || cmd_to_lydown(@event))
      else
        once = @event[:once] ? '\once ' : ''
        cmd = "#{once}\\#{@event[:key]} #{(@event[:arguments] || []).join(' ')} "
        @work.emit(:music, cmd)
      end
    end
    
    def cmd_to_lydown(event)
      cmd = "\\#{event[:key]}"
      if event[:arguments]
        cmd << ":"
        cmd << event[:arguments].map {|a| a.inspect}.join(':')
      end
      cmd
    end
  end
end
