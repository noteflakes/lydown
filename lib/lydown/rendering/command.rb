module Lydown::Rendering
  class Command < Base
    include Notes
    
    def translate
      if respond_to?("cmd_#{@event[:key]}".to_sym)
        return send("cmd_#{@event[:key]}".to_sym)
      end
      
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
    
    def cmd_instr
      return unless (@context['options/mode'] == :score)
      markup = Staff.inline_part_title(
        @context,
        @context[:part], 
        @event[:arguments] && @event[:arguments][0]
      )
      @context.emit(:music, markup)
    end
  end
end
