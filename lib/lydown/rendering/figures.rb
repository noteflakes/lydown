module Lydown::Rendering
  module Figures
    def add_figures(figures, value)
      if @work['process/running_values']
        @work['process/running_values'].each do |v|
          silence = "s"
          if v != @work['process/last_figures_value']
            silence << v
            @work['process/last_figures_value'] = v
          end
          @work.emit(:figures, "#{silence} ")
        end
        @work['process/running_values'] = []
      end

      figures = lilypond_figures(figures)
      if value != @work['process/last_figures_value']
        figures << value
        @work['process/last_figures_value'] = value
      end

      @work.emit(:figures, "#{figures} ")
      @work.emit(:figures, EXTENDERS_ON) if @event[:figure_extenders_on]
      @work.emit(:figures, EXTENDERS_OFF) if @event[:figure_extenders_off]
    end

    def add_stand_alone_figures(figures)
      if @work['process/running_values']
        # for stand alone figures, we regard the stand alone figure as being
        # aligned to the last note. Therefore we pop its value from
        # running_values array.
        @work['process/running_values'].pop
      end
      value =  @work['process/figures_duration_value'] || @work['process/last_value']
      add_figures(figures, value)
    end

    def lilypond_figures(figures)
      check_tenues(figures)
      "<#{translate_figures(figures)}>"
    end

    def check_tenues(figures)
      next_event = next_figures_event
      unless next_event
        # if next figures event is not found, check if there is a tenue, and
        # add extenders off flag
        @event[:figure_extenders_off] = true if @event[:tenue]
        return
      end

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
    EXTENDERS_ON = "\\bassFigureExtendersOn "
    EXTENDERS_OFF = "\\bassFigureExtendersOff "

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
