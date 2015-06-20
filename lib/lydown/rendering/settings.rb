module Lydown::Rendering
  class Setting < Base
    SETTING_KEYS = [
      'key', 'time', 'pickup', 'clef', 'part', 'movement', 'tempo',
      'accidentals', 'beams', 'end_barline', 'macros', 'empty_staves'
    ]

    RENDERABLE_SETTING_KEYS = [
      'key', 'time', 'clef', 'beams'
    ]

    ALLOWED_SETTING_VALUES = {
      'accidentals' => ['manual', 'auto'],
      'beams' => ['manual', 'auto'],
      'empty_staves' => ['hide', 'show']
    }

    def translate
      key = @event[:key]
      value = @event[:value]
      level = @event[:level] || 0

      unless (level > 0) || SETTING_KEYS.include?(key)
        raise LydownError, "Invalid setting (#{key})"
      end

      if level == 0
        value = check_setting_value(key, value)
        @work[key] = value
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
      else
        # nested settings
        l, path = 0, ''
        while l < level
          path << "#{@work['process/setting_levels'][l]}/"; l += 1
        end
        path << key
        @work[path] = value
      end

      @work['process/setting_levels'] ||= {}
      @work['process/setting_levels'][level] = key
    end

    def check_setting_value(key, value)
      if key == 'key'
        # process shorthand notation
        if value =~ /^([a-gA-G])[\+\-]*$/
          mode = $1.downcase == $1 ? 'minor' : 'major'
          value = "#{value.downcase} #{mode}"
        end
      elsif ALLOWED_SETTING_VALUES[key]
        unless ALLOWED_SETTING_VALUES[key].include?(value)
          raise LydownError, "Invalid value for setting #{key}: #{value.inspect}"
        end
      end
      value
    end

    def render_setting(key, value)
      setting = ""
      case key
      when 'time'
        cadenza_mode = @work[:cadenza_mode]
        should_cadence = value == 'unmetered'
        @work[:cadenza_mode] = should_cadence

        if should_cadence && !cadenza_mode
          setting = "\\cadenzaOn "
        elsif !should_cadence && cadenza_mode
          setting = "\\cadenzaOff "
        end

        unless should_cadence
          signature = value.sub(/[0-9]+$/) { |m| LILYPOND_DURATIONS[m] || m }
          setting << "\\#{key} #{signature} "
        end
      when 'key'
        # If the next event is a key signature, no need to emit this one
        e = next_event
        return if e && (e[:type] == :setting) && (e[:key] == 'key')

        unless value =~ /^([a-g][\+\-]*) (major|minor)$/
          raise LydownError, "Invalid key signature #{value.inspect}"
        end

        note = Lydown::Rendering::Accidentals.lilypond_note_name($1)
        mode = $2
        setting = "\\#{key} #{note} \\#{mode} "
      when 'clef'
        setting = "\\#{key} \"#{value}\" "
      when 'beams'
        setting = (value == 'manual') ? '\autoBeamOff ' : '\autoBeamOn '
      else
        setting = "\\#{key} #{value} "
      end

      @work.emit(:music, setting)
    end
  end
end


