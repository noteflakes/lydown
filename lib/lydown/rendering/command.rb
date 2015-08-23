module Lydown::Rendering
  class Command < Base
    include Notes
    
    COMMAND_ALIGNMENT = {
      '<' => '\\right-align',
      '>' => '\\left-align',
      '|' => '\\center-align'
    }

    def translate
      key = @event[:key]
      if key =~ /([\<\>\|])([a-zA-Z0-9]+)/
        @event[:alignment] =  COMMAND_ALIGNMENT[$1]
        key = $2
      end
      # Is there a command handler
      if respond_to?("cmd_#{key}".to_sym)
        return send("cmd_#{key}".to_sym)
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
        part: @context[:part], 
        name: @event[:arguments] && @event[:arguments][0],
        alignment: @event[:alignment]
      )
      @context.emit(:music, markup)
    end
    
    def cmd_tempo
      unless @event[:arguments] && @event[:arguments].size == 1
        raise LydownError, "Invalid or missing tempo argument"
      end
      
      tempo = @event[:arguments].first
      if tempo =~ /^\((.+)\)$/
        format = @context['options/format']
        return unless (format == :midi) || (format == :mp3)
        tempo = $1
      end
      
      @context.emit(:music, "\\tempo #{tempo} ")
    end
  end
end
