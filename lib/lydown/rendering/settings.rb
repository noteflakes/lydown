module Lydown::Rendering
  class Setting < Base
    SETTING_KEYS = [
      'key', 'time', 'pickup', 'clef', 'part', 'movement',
      'accidentals', 'beams', 'end_barline'
    ]

    RENDERABLE_SETTING_KEYS = [
      'key', 'time', 'clef', 'beams'
    ]
    
    ALLOWED_SETTING_VALUES = {
      'accidentals' => ['manual', 'auto'],
      'beams' => ['manual', 'auto']
    }
    
    def translate
      key = @event[:key]
      value = @event[:value]
      
      unless SETTING_KEYS.include?(key)
        raise Lydown, "Invalid setting (#{key})"
      end
      
      @work[key] = check_setting_value(key, value)

      case key
      when 'part'
        # when changing parts we repeat the last set time and key signature
        render_setting('time', @work[:time]) unless @work[:time] == '4/4'
        key =  @work[:key]
        render_setting('key', key) unless key == 'c major'

        @work.reset_context(:part)
      when 'movement'
        @work.reset_context(:movement)
      end

      if RENDERABLE_SETTING_KEYS.include?(key)
        render_setting(key, value)
      end
    end
  
    def check_setting_value(key, value)
      if ALLOWED_SETTING_VALUES[key]
        unless ALLOWED_SETTING_VALUES[key].include?(value)
          raise LydownError, "Invalid value for setting #{key}: #{value.inspect}"
        end
      end
      value
    end
    
    def render_setting(key, value)
      setting = "\\#{key} "
      case key
      when 'time'
        setting << value.sub(/[0-9]+$/) { |m| LILYPOND_DURATIONS[m] || m }
      when 'key'
        unless value =~ /^([a-g][\+\-]*) (major|minor)$/
          raise LydownError, "Invalid key signature #{value.inspect}"
        end
        
        note = Lydown::Rendering::Accidentals.lilypond_note_name($1)
        mode = $2
        setting << "#{note} \\#{mode}"
      when 'clef'
        setting << "\"#{value}\""
      when 'beams'
        setting = (value == 'manual') ? '\autoBeamOff' : '\autoBeamOn'
      else
        setting << value
      end
      
      setting << ' '
      
      @work.emit(:music, setting)
    end
  end
end