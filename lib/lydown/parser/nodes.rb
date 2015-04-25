module Lydown::Parsing
  module LydownNode
    def _compile(element, opus)
      if element.elements
        element.elements.each do |e|
          e.respond_to?(:compile) ? e.compile(opus) : _compile(e, opus)
        end
      end    
    end

    def compile(opus)
      _compile(self, opus)
    end
    
    def add_note(opus, note)
      return add_macro_note(opus, note) if opus.context[:duration_macro]
    
      value = opus.context[:duration_values].first
      opus.context[:duration_values].rotate!
    
      # only add the value if different than the last used
      if value == opus.context[:last_value]
        value = ''
      else
        opus.context[:last_value] = value
      end
      opus.add_music(note + value + ' ')
    end
  
    def add_macro_note(opus, note)
      opus.context[:macro_group] ||= opus.context[:duration_macro].clone
      _found = false # underscore found?

      # replace place holder and repeaters in macro group with actual note
      opus.context[:macro_group].gsub!(/[_@]/) do |match|
        if match == '_' && _found
          match
        else
          _found = true if match == '_'
          note
        end
      end
    
      unless opus.context[:macro_group].include?('_')
        # stash macro, in order to compile macro group
        macro = opus.context[:duration_macro]
        opus.context[:duration_macro] = nil

        opus.compile(opus.context[:macro_group])

        # restore macro
        opus.context[:duration_macro] = macro
        opus.context[:macro_group] = nil
      end
    end
  end

  module NullNode
    def compile(opus)
      ''
    end
  end
  
  SETTING_KEYS = [
    'key', 'time', 'pickup', 'clef', 'part', 'movement'
  ]
  
  module SettingKeyNode
    def compile(opus)
      if SETTING_KEYS.include?(text_value)
        opus.context['parser/setting_key'] = text_value
      end
    end
  end
  
  module SettingValueNode
    def compile(opus)
      key = opus.context['parser/setting_key']
      value = text_value.strip
      return unless key

      emit_setting(opus, key, value)
      opus.context['parser/setting_key'] = nil
      
    end
    
    RENDERABLE_SETTING_KEYS = [
      'key', 'time', 'clef'
    ]
    
    def emit_setting(opus, key, value)
      opus.context[key] = value
      if RENDERABLE_SETTING_KEYS.include?(key)
        value = transform_value(opus, key, value)
        opus.add_music("\\#{key} #{value} ")
      end
    end
    
    def transform_value(opus, key, value)
      case key
      when 'time'
        value.sub(/[0-9]+$/) {|m| LILYPOND_DURATIONS[m] || m}
      else
        value
      end
    end
  end

  LILYPOND_DURATIONS = {
    '6' => '16',
    '3' => '32'
  }

  module DurationValueNode
    
    def compile(opus)
      value = text_value.sub(/^[0-9]+/) {|m| LILYPOND_DURATIONS[m] || m}
      
      opus.context[:duration_values] = [value]
      opus.context[:duration_macro] = nil unless opus.context[:macro_group]
    end
  end

  module NoteNode
    include LydownNode
    
    def compile(opus)
      add_note(opus, text_value)
    end
  end

  module RestNode
    include LydownNode
    
    def compile(opus)
      add_note(opus, text_value)
    end
  end
  
  module DurationMacroExpressionNode
    include LydownNode
    
    def compile(opus)
      opus.context[:duration_macro] = text_value
    end
  end
end
