module Lydown::Rendering
  class Command < Base
    include Notes
    
    def translate
      if @context['process/duration_macro']
        add_macro_event(@event[:raw] || cmd_to_lydown(@event))
      else
        once = @event[:once] ? '\once ' : ''
        arguments = (@event[:arguments] || []).map do |a|
          format_argument(@event[:key], a)
        end.join(' ')
        cmd = "#{once}\\#{@event[:key]} #{arguments} "
        @context.emit(:music, cmd)
      end
    end
    
    def format_argument(command_key, argument)
      case command_key
      when 'tempo', 'mark'
        "\"#{argument}\""
      else
        argument
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
