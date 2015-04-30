module Lydown::Rendering
  class Setting < Base
    SETTING_KEYS = [
      'key', 'time', 'pickup', 'clef', 'part', 'movement',
      'accidentals', 'beams'
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
      
      @opus[key] = check_setting_value(key, value)
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
      when 'beams'
        setting = (value == 'manual') ? '\autoBeamOff' : '\autoBeamOn'
      else
        setting << value
      end
      
      setting << ' '
      
      @opus.emit(:music, setting)
    end
  end
end