module Lydown::Parsing
  module Root
    def _to_stream(element, stream, opts)
      if element.elements
        element.elements.each do |e|
          e.respond_to?(:to_stream) ? 
            e.to_stream(stream, opts) : 
            _to_stream(e, stream, opts)
        end
      end
      stream
    end
    
    def to_stream(stream = [], opts = {})
      _to_stream(self, stream, opts)
      stream
    end
    
    
    
    def event_hash(stream, opts, hash = {})
      if source = opts[:source]
        last = stream.last
        if last && last[:type] == :source_ref
          line, column = last[:line], last[:column]
        else
          line, column = source.find_line_and_column(interval.first)
        end
        hash.merge({
          filename: opts[:filename],
          source: source,
          line: line,
          column: column
        })
      else
        hash
      end
    end
  end

  module CommentContent
    def to_stream(stream, opts)
      stream << {type: :comment, content: text_value.strip}
    end
  end

  module Setting
    include Root

    def to_stream(stream, opts)
      level = (text_value =~ /^([\s]+)/) ? ($1.length / 2) : 0
      @setting = {type: :setting, level: level}
      _to_stream(self, stream, opts)
    end

    def setting
      @setting
    end

    def emit_setting(stream)
      stream << @setting
    end

    module Key
      def to_stream(stream, opts)
        parent.setting[:key] = text_value
      end
    end

    module Value
      def to_stream(stream, opts)
        parent.setting[:value] = text_value.strip
        parent.emit_setting(stream)
      end
    end
  end

  module DurationValue
    def to_stream(stream, opts)
      stream << {type: :duration, value: text_value}
    end
  end

  module TupletValue
    def to_stream(stream, opts)
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

  module GraceDuration
    GRACE_KIND = {
      nil => :grace,
      '/' => :acciaccatura,
      '^' => :appoggiatura
    }
    
    def to_stream(stream, opts)
      if text_value =~ /^\$([\/\^])?(\d+)$/
        stream << {type: :grace, value: $2, kind: GRACE_KIND[$1]}
      end
    end
  end

  module Note
    include Root

    def to_stream(stream, opts)
      note = event_hash(stream, opts, {type: :note, raw: text_value})
      _to_stream(self, note, opts)
      stream << note
    end

    module Head
      def to_stream(note, opts)
        # remove octave marks from note head (this is only in case the order
        # accidental-octave was reversed)
        head = text_value.gsub(/[',]+/) {|m| note[:octave] = m; ''}
        note[:head] = head
      end
    end

    module Octave
      def to_stream(note, opts)
        note[:octave] = text_value
      end
    end

    module AccidentalFlag
      def to_stream(note, opts)
        note[:accidental_flag] = text_value
      end
    end

    module Expression
      def to_stream(note, opts)
        note[:expressions] ||= []
        note[:expressions] << text_value
      end
    end
  end
  
  module Chord
    include Root
    
    def to_stream(stream, opts)
      chord = {type: :chord, notes: []}
      _to_stream(self, chord[:notes], opts)
      stream << chord
    end
  end

  module FiguresComponent
    def to_stream(note, opts)
      note[:figures] ||= []
      note[:figures] << text_value
    end
  end

  module StandAloneFigures
    include Root

    def to_stream(stream, opts)
      note = {type: :stand_alone_figures}
      _to_stream(self, note, opts)
      stream << note
    end
  end

  module Phrasing
    module BeamOpen
      def to_stream(stream, opts)
        stream << {type: :beam_open}
      end
    end

    module BeamClose
      def to_stream(stream, opts)
        stream << {type: :beam_close}
      end
    end

    module SlurOpen
      def to_stream(stream, opts)
        stream << {type: :slur_open}
      end
    end

    module SlurClose
      def to_stream(stream, opts)
        stream << {type: :slur_close}
      end
    end
  end

  module Tie
    def to_stream(stream, opts)
      stream << {type: :tie}
    end
  end

  module ShortTie
    def to_stream(stream, opts)
      stream << {type: :short_tie}
    end
  end

  module Rest
    include Root
    
    def to_stream(stream, opts)
      rest = {type: :rest, raw: text_value, head: text_value[0]}
      if text_value =~ /^R(\*([0-9]+))?$/
        rest[:multiplier] = $2 || '1'
      end

      _to_stream(self, rest, opts)

      stream << rest
    end
  end

  module Silence
    def to_stream(stream, opts)
      stream << {type: :silence, raw: text_value, head: text_value[0]}
    end
  end

  module DurationMacroExpression
    def to_stream(stream, opts)
      stream << {type: :duration_macro, macro: text_value}
    end
  end

  module Lyrics
    include Root
    def to_stream(stream, opts)
      o = {type: :lyrics}
      _to_stream(self, o, opts)
      stream << o
    end
    
    module Content
      def to_stream(o, opts)
        if o[:content]
          o[:content] << ' ' << text_value
        else
          o[:content] = text_value
        end
      end
    end
    
    module QuotedContent
      def to_stream(o, opts)
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
    def to_stream(o, opts)
      idx = (text_value =~ /\(([\d]+)\)/) && $1.to_i
      if idx.nil?
        raise LydownError, "Invalid stream index (#{text_value.inspect})"
      end
      o[:stream_index] = idx
    end
  end

  module Barline
    def to_stream(stream, opts)
      stream << {type: :barline, barline: text_value}
    end
  end
  
  module Command
    include Root
    def to_stream(stream, opts)
      cmd = {type: :command, raw: text_value}
      cmd[:once] = true if text_value =~ /^\\\!/
      _to_stream(self, cmd, opts)
      stream << cmd
    end
    
    SETTING_KEYS = %w{time key clef}
    
    module Key
      def to_stream(cmd, opts)
        cmd[:key] = text_value
        if SETTING_KEYS.include?(text_value)
          cmd[:type] = :setting
        end
      end
    end
    
    module Argument
      def to_stream(cmd, opts)
        if text_value =~ /^"(.+)"$/
          value = $1.unescape
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
    def to_stream(stream, opts)
      voice = (text_value =~ /^([1234])/) && $1.to_i
      stream << {type: :voice_select, voice: voice}
    end
  end
  
  module SourceRef
    include Root
    def to_stream(stream, opts)
      ref = {type: :source_ref, raw: text_value}
      _to_stream(self, ref, opts)
      stream << ref
    end
    
    module Line
      def to_stream(ref, opts)
        ref[:line] = text_value.to_i
      end
    end
    
    module Column
      def to_stream(ref, opts)
        ref[:column] = text_value.to_i
      end
    end
  end
end
