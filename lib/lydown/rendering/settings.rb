# encoding: utf-8

require 'fileutils'
require 'pathname'

module Lydown::Rendering
  class Setting < Base
    include Notes
    
    SETTING_KEYS = [
      'key', 'time', 'pickup', 'clef', 'part', 'movement', 'tempo',
      'accidentals', 'beams', 'end_barline', 'macros', 'empty_staves',
      'midi_tempo', 'instrument_names', 'instrument_name_style',
      'parts', 'score', 'movement_source', 'colla_parte', 'include',
      'mode', 'nomode', 'bar_numbers', 'document', 'notation_size'
    ]

    RENDERABLE_SETTING_KEYS = [
      'key', 'time', 'clef', 'beams'
    ]

    ALLOWED_SETTING_VALUES = {
      'accidentals' => ['manual', 'auto'],
      'beams' => ['manual', 'auto'],
      'empty_staves' => ['hide', 'show'],
      'instrument_names' => ['hide', 'show', 'inline', 'inline-right-align', 'inline-center-align'],
      'instrument_name_style' => ['normal', 'smallcaps'],
      'page_break' => ['none', 'before', 'after', 'before and after', 'blank page before'],
      'mode' => ['score', 'part', 'none'],
      'bar_numbers' => ['hide', 'shows'],
      'notation_size' => ['huge', 'large', 'normalsize', 'small', 'tiny', 'teeny']
    }

    def translate
      # if setting while doing a macro, insert it into the current macro group
      if @context['process/duration_macro'] && @event[:raw]
        return add_macro_event(@event[:raw])
      end
      
      key = @event[:key]
      value = @event[:value]
      level = @event[:level] || 0
      
      unless (level > 0) || SETTING_KEYS.include?(key)
        raise LydownError, "Invalid setting (#{key})"
      end

      value = check_setting_value(key, value)

      if level == 0
        movement = @context[:movement]
        case key
        when 'part'
          @context[:part] = value
          @context.set_part_context(value)
          
          # when changing parts we repeat the last set time and key signature
          time = @context.get_current_setting(:time)
          key =  @context.get_current_setting(:key)

          render_setting('time', time) unless time == '4/4'
          render_setting('key', key) unless key == 'c major'

          @context.reset(:part)
        when 'movement'
          @context[:movement] = value
          @context.reset(:movement)
        when 'include'
          add_include(:includes, value)
        when 'mode'
          set_mode(value.nil? ? :none : value.to_sym)
        when 'nomode'
          set_mode(:none)
        else
          @context.set_setting(key, value) unless @event[:ephemeral]
        end

        if RENDERABLE_SETTING_KEYS.include?(key)
          render_setting(key, value)
        end
      else
        # nested settings
        l, path = 0, ''
        while l < level
          path << "#{@context['process/setting_levels'][l]}/"; l += 1
        end
        case key
        when 'include'
          add_include(path + 'includes', value)
        else
          path << key
          @context.set_setting(path, value)
        end
      end

      @context['process/setting_levels'] ||= {}
      @context['process/setting_levels'][level] = key
    end

    def check_setting_value(key, value)
      if key == 'key'
        # process shorthand notation
        if value =~ /^([a-gA-G])[\+\-#ß]*$/
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
        cadenza_mode = @context[:cadenza_mode]
        should_cadence = value == 'unmetered'
        @context[:cadenza_mode] = should_cadence

        if should_cadence && !cadenza_mode
          setting = "\\cadenzaOn "
        elsif !should_cadence && cadenza_mode
          setting = "\\cadenzaOff "
        end

        unless should_cadence
          signature = value.sub(/[0-9]+$/) { |m| LILYPOND_DURATIONS[m] || m }
          setting << "\\time #{signature} "
        end
      when 'key'
        # If the next event is a key signature, no need to emit this one
        e = next_event
        return if e && (e[:type] == :setting) && (e[:key] == 'key')

        unless value =~ /^([A-Ga-g][\+\-#ß]*) (major|minor)$/
          raise LydownError, "Invalid key signature #{value.inspect}"
        end

        note = Lydown::Rendering::Accidentals.lilypond_note_name($1)
        mode = $2
        setting = "\\#{key} #{note} \\#{mode} "
      when 'clef'
        setting = "\\#{key} \"#{value}\" "
        # If no music is there, and we're rendering a clef command, we need 
        # tell lydown to not render a first clef command inside the Staff 
        # context.
        unless @context.get_current_setting(:got_music)
          @context.set_setting(:inhibit_first_clef, true)
        end
      when 'beams'
        setting = (value == 'manual') ? '\autoBeamOff ' : '\autoBeamOn '
      else
        setting = "\\#{key} #{value} "
      end

      @context.emit(:music, setting)
    end
    
    def set_mode(mode)
      @context['process/mode'] = (mode == :none) ? nil : mode
    end
    
    def add_include(includes_path, path)
      includes = @context.get_current_setting(includes_path) || []

      source_filename = @context['process/last_filename']
      if source_filename
        absolute_path = File.expand_path(
          File.join(File.dirname(source_filename), path)
        )
        # calculate relative path to working directory
        pwd = Pathname.new(FileUtils.pwd)
        includes << Pathname.new(absolute_path).relative_path_from(pwd).to_s
      else
        includes << path
      end

      @context.set_setting(includes_path, includes)
    end
  end
end


