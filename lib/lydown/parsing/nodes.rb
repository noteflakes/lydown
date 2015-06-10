module Lydown::Parsing
  module Root
    def _to_stream(element, stream)
      if element.elements
        element.elements.each do |e|
          e.respond_to?(:to_stream) ? e.to_stream(stream) : _to_stream(e, stream)
        end
      end
      stream
    end

    def to_stream(stream = [])
      _to_stream(self, stream)
      stream
    end
  end

  module CommentContent
    def to_stream(stream)
      stream << {type: :comment, content: text_value.strip}
    end
  end

  module Setting
    include Root

    def to_stream(stream)
      level = (text_value =~ /^([\s]+)/) ? ($1.length / 2) : 0
      @setting = {type: :setting, level: level}
      _to_stream(self, stream)
    end

    def setting
      @setting
    end

    def emit_setting(stream)
      stream << @setting
    end

    module Key
      def to_stream(stream)
        parent.setting[:key] = text_value
      end
    end

    module Value
      def to_stream(stream)
        parent.setting[:value] = text_value.strip
        parent.emit_setting(stream)
      end
    end
  end

  module DurationValue
    def to_stream(stream)
      stream << {type: :duration, value: text_value}
    end
  end

  module TupletValue
    def to_stream(stream)
      if text_value =~ /^(\d+)%((\d+)\/(\d+))?$/
        value, fraction, group_length = $1, $2, $4
        unless fraction
          fraction = '3/2'
          group_length = '2'
        end

        stream << {
          type: :tuplet_duration,
          value: value,
          fraction: fraction,
          group_length: group_length
        }
      end
    end
  end

  module Note
    include Root

    def to_stream(stream)
      note = {type: :note, raw: text_value}
      _to_stream(self, note)
      stream << note
    end

    module Head
      def to_stream(note)
        # remove octave marks from note head (this is only in case the order
        # accidental-octave was reversed)
        head = text_value.gsub(/[',]+/) {|m| note[:octave] = m; ''}
        note[:head] = head
      end
    end

    module Octave
      def to_stream(note)
        note[:octave] = text_value
      end
    end

    module AccidentalFlag
      def to_stream(note)
        note[:accidental_flag] = text_value
      end
    end

    module Expression
      def to_stream(note)
        note[:expressions] ||= []
        note[:expressions] << text_value
      end
    end
  end

  module FiguresComponent
    def to_stream(note)
      note[:figures] ||= []
      note[:figures] << text_value
    end
  end

  module StandAloneFigures
    include Root

    def to_stream(stream)
      note = {type: :stand_alone_figures}
      _to_stream(self, note)
      stream << note
    end
  end

  module Phrasing
    module BeamOpen
      def to_stream(stream)
        stream << {type: :beam_open}
      end
    end

    module BeamClose
      def to_stream(stream)
        stream << {type: :beam_close}
      end
    end

    module SlurOpen
      def to_stream(stream)
        stream << {type: :slur_open}
      end
    end

    module SlurClose
      def to_stream(stream)
        stream << {type: :slur_close}
      end
    end
  end

  module Tie
    def to_stream(stream)
      stream << {type: :tie}
    end
  end

  module ShortTie
    def to_stream(stream)
      stream << {type: :short_tie}
    end
  end

  module Rest
    include Root
    
    def to_stream(stream)
      rest = {type: :rest, raw: text_value, head: text_value[0]}
      if text_value =~ /^R(\*([0-9]+))?$/
        rest[:multiplier] = $2 || '1'
      end

      _to_stream(self, rest)

      stream << rest
    end
  end

  module Silence
    def to_stream(stream)
      stream << {type: :silence, raw: text_value, head: text_value[0]}
    end
  end

  module DurationMacroExpression
    def to_stream(stream)
      stream << {type: :duration_macro, macro: text_value}
    end
  end

  module Lyrics
    include Root
    def to_stream(stream)
      o = {type: :lyrics}
      _to_stream(self, o)
      stream << o
    end
    
    module Content
      def to_stream(o)
        if o[:content]
          o[:content] << ' ' << text_value
        else
          o[:content] = text_value
        end
      end
    end
    
    module QuotedContent
      def to_stream(o)
        if text_value =~ /^"(.+)"$/
          content = $1
        else
          raise LydownError, "Unexpected quoted lyrics content (#{text_value.inspect})"
        end

        if o[:content]
          o[:content] << ' ' << content
        else
          o[:content] = content
        end
      end
    end
  end
  
  module StreamIndex
    def to_stream(o)
      idx = (text_value =~ /\(([\d]+)\)/) && $1.to_i
      if idx.nil?
        raise LydownError, "Invalid stream index (#{text_value.inspect})"
      end
      o[:stream_index] = idx
    end
  end

  module Barline
    def to_stream(stream)
      stream << {type: :barline, barline: text_value}
    end
  end
  
  module Command
    include Root
    def to_stream(stream)
      cmd = {type: :command}
      cmd[:once] = true if text_value =~ /^\\\!/
      _to_stream(self, cmd)
      stream << cmd
    end
    
    SETTING_KEYS = %w{time key}
    
    module Key
      def to_stream(cmd)
        cmd[:key] = text_value
        if SETTING_KEYS.include?(text_value)
          cmd[:type] = :setting
        end
      end
    end
    
    module Argument
      def to_stream(cmd)
        if text_value =~ /^"(.+)"$/
          value = $1
        else
          value = text_value
        end
        
        if cmd[:type] == :setting
          cmd[:value] = value
        else
          cmd[:arguments] ||= []
          cmd[:arguments] << value
        end
      end
    end
  end
  
  module VoiceSelector
    def to_stream(stream)
      voice = (text_value =~ /^([1234])/) && $1.to_i
      stream << {type: :voice_select, voice: voice}
    end
  end
end
