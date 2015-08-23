module Lydown::Rendering
  module Figures
    BLANK_EXTENDER_START  = '<->'
    BLANK_EXTENDER_STOP   = '<.>'
    BLANK_EXTENDER        = '<_>'

    EXTENDERS_ON = "\\bassFigureExtendersOn "
    EXTENDERS_OFF = "\\bassFigureExtendersOff "
    
    def add_figures(figures, value)
      # Add fill-in silences to catch up with music stream
      if @context['process/running_values']
        @context['process/running_values'].each do |v|
          silence = @context['process/blank_extender_mode'] ?
            '<_>' : 's'
          if v != @context['process/last_figures_value']
            silence << v
            @context['process/last_figures_value'] = v
          end
          @context.emit(:figures, "#{silence} ")
        end
        @context['process/running_values'] = []
      end

      figures = lilypond_figures(figures)
      if figures == BLANK_EXTENDER_START
        @context['process/blank_extender_mode'] = true
        figures = BLANK_EXTENDER
        @context.emit(:figures, EXTENDERS_ON)
      elsif figures == BLANK_EXTENDER_STOP
        @context['process/blank_extender_mode'] = false
        @context.emit(:figures, EXTENDERS_OFF)
        return
      end
      
      @context['process/last_figures'] = figures
      if value != @context['process/last_figures_value']
        figures << value
        @context['process/last_figures_value'] = value
      end

      @context.emit(:figures, "#{figures} ")
      @context.emit(:figures, EXTENDERS_ON) if @event[:figure_extenders_on]
      @context.emit(:figures, EXTENDERS_OFF) if @event[:figure_extenders_off]
    end

    def add_stand_alone_figures(figures)
      if @context['process/running_values']
        # for stand alone figures, we regard the stand alone figure as being
        # aligned to the last note. Therefore we pop its value from
        # running_values array.
        @context['process/running_values'].pop
      end
      value =  @context['process/figures_duration_value'] || @context['process/last_value']
      add_figures(figures, value)
    end

    def lilypond_figures(figures)
      if figures
        check_tenues(figures)
        "<#{translate_figures(figures)}>"
      else
        "s"
      end
    end

    def check_tenues(figures)
      next_event = next_figures_event
      unless next_event
        # if next figures event is not found, check if there is a tenue, and
        # add extenders off flag
        @event[:figure_extenders_off] = true if @event[:tenue]
        return
      end

      if next_event[:figures]
        next_event[:tenue] = next_event[:figures].include?('_')
        if next_event[:tenue] && !@event[:tenue]
          @event[:figure_extenders_on] = true
        elsif !next_event[:tenue] && @event[:tenue]
          @event[:figure_extenders_off] = true
        end

        # transform underscores into figure components
        next_event[:figures].each_with_index do |component, idx|
          next_event[:figures][idx] = @event[:figures][idx] if component == '_'
        end
      end
    end

    def translate_figures(figures)
      figures.map {|n| n.gsub(ALTERATION_RE) {|a| ALTERATION[a]}}.join(' ')
    end

    ALTERATION_RE = /[#bh`']/
    ALTERATION = {
      '#' => '_+',
      'b' => '_-',
      'h' => '_!',
      '`' => '\\\\',
      "'" => "/"
    }
    HIDDEN_FORMAT = "\\once \\override BassFigure #'implicit = ##t"

    def next_figures_event
      idx = @idx + 1
      while idx < @stream.size
        event = @stream[idx]
        case event[:type]
        when :setting
          if ['part', 'movement'].include? event[:key]
            return nil
          end
        when :note
          return event if event[:figures]
        when :stand_alone_figures
          return event
        end
        idx += 1
      end
    end
  end
end
