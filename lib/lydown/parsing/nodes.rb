module Lydown::Parsing
  module RootMethods
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
    
    def each_child(ele = nil, &block)
      ele ||= elements
      return unless ele

      ele.each do |e|
        block[e] if e.respond_to?(:to_stream)
        each_child(e.elements, &block) if e.elements
      end
    end
    
    def to_stream(stream = [], opts = {})
      _to_stream(self, stream, opts)
      stream
    end
    
    def event_hash(stream, opts, hash = {})
      if opts[:proof_mode] && (source = opts[:source])
        last = stream.last
        if last && (last[:type] == :source_ref) && last[:line]
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
    ensure
      if $progress_bar
        $progress_bar.progress = (opts[:progress_base] || 0) + interval.end
      end
    end
    
    def add_event(stream, opts, type)
      stream << event_hash(stream, opts, {type: type})
    end
  end
  
  class Root < Treetop::Runtime::SyntaxNode
    include RootMethods
    def initialize(*args)
      super
      if $progress_bar
        $progress_bar.progress = interval.end
      end
    end
  end

  class CommentContent < Root
    def to_stream(stream, opts)
      stream << {type: :comment, content: text_value.strip}
    end
  end

  class Setting < Root
    def to_stream(stream, opts)
      level = (text_value =~ /^([\s]+)/) ? ($1.length / 2) : 0
      @setting = event_hash(stream, opts, {
        type: :setting, level: level
      })
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

  class DurationValue < Root
    GRACE_KIND = {
      '°' => :grace,
      '`' => :acciaccatura,
      '^' => :appoggiatura
    }

    def to_stream(stream, opts)
      if text_value.strip =~ /^(.+)([°`^])$/
        event = {
          type: :grace,
          value: $1,
          kind: GRACE_KIND[$2]
        }
      else
        event = {
          type: :duration,
          value: text_value.strip
        }
        if event[:value] =~ /\!/
          event[:value].gsub!('!', '')
          event[:cross_bar_dotting] = true
        end
      end
      
      stream << event_hash(stream, opts, event)
    end
  end

  class TupletValue < Root
    def to_stream(stream, opts)
      if text_value =~ /^(\d+)%((\d+)\/(\d+))?$/
        value, fraction, group_length = $1, $2, $4
        unless fraction
          fraction = '3/2'
          group_length = '2'
        end

        stream << event_hash(stream, opts, {
          type: :tuplet_duration,
          value: value,
          fraction: fraction,
          group_length: group_length
        })
      end
    end
  end

  class Note < Root
    def to_stream(stream, opts)
      note = event_hash(stream, opts, {
        type: :note, raw: text_value
      })
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
  
  class Chord < Root
    def to_stream(stream, opts)
      chord = event_hash(stream, opts, {
        type: :chord, notes: []
      })
      each_child do |c|
        if c.is_a?(Note)
          c.to_stream(chord[:notes], opts)
        elsif c.is_a?(Note::Expression)
          c.to_stream(chord, opts)
        end
      end
           
      # _to_stream(self, chord[:notes], opts)
      stream << chord
    end
  end

  module FiguresComponent
    def to_stream(note, opts)
      note[:figures] ||= []
      note[:figures] << text_value
    end
  end

  class StandAloneFigures < Root
    def to_stream(stream, opts)
      note = event_hash(stream, opts, {
        type: :stand_alone_figures
      })
      _to_stream(self, note, opts)
      stream << note
    end
  end

  module Phrasing
    class BeamOpen < Root
      def to_stream(stream, opts)
        add_event(stream, opts, :beam_open)
      end
    end

    class BeamClose < Root
      def to_stream(stream, opts)
        add_event(stream, opts, :beam_close)
      end
    end

    class SlurOpen < Root
      def to_stream(stream, opts)
        add_event(stream, opts, :slur_open)
      end
    end

    class SlurClose < Root
      def to_stream(stream, opts)
        add_event(stream, opts, :slur_close)
      end
    end
  end

  class Tie < Root
    def to_stream(stream, opts)
      stream << event_hash(stream, opts, {type: :tie})
    end
  end

  class ShortTie < Root
    def to_stream(stream, opts)
      stream << event_hash(stream, opts, {type: :short_tie})
    end
  end

  class Rest < Root
    def to_stream(stream, opts)
      rest = event_hash(stream, opts, {
        type: :rest, raw: text_value, head: text_value[0]
      })
      if text_value =~ /^R(\*([0-9]+))?/
        rest[:multiplier] = $2 || '1'
      end
      _to_stream(self, rest, opts)

      stream << rest
    end
  end

  class Silence < Root
    def to_stream(stream, opts)
      silence = event_hash(stream, opts, {
        type: :silence, raw: text_value, head: text_value[0]
      })
      if text_value =~ /^S(\*([0-9]+))?/
        silence[:multiplier] = $2 || '1'
      end
      _to_stream(self, silence, opts)
      stream << silence
    end
  end

  module DurationMacroExpression
    include RootMethods
    def to_stream(stream, opts)
      stream << event_hash(stream, opts, {
        type: :duration_macro, macro: text_value
      })
    end
  end

  class Lyrics < Root
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
  
  class StreamIndex < Root
    def to_stream(o, opts)
      idx = (text_value =~ /\(([\d]+)\)/) && $1.to_i
      if idx.nil?
        raise LydownError, "Invalid stream index (#{text_value.inspect})"
      end
      o[:stream_index] = idx
    end
  end

  module Barline
    include RootMethods
    def to_stream(stream, opts)
      stream << event_hash(stream, opts, {
        type: :barline, 
        barline: text_value
      })
    end
  end
  
  class Command < Root
    def to_stream(stream, opts)
      cmd = event_hash(stream, opts, {
        type: :command, raw: text_value
      })
      cmd[:once] = true if text_value =~ /^\\\!/
      _to_stream(self, cmd, opts)
      stream << cmd
    end
    
    SETTING_KEYS = %w{time key clef pickup mode nomode}
    NON_EPHEMERAL_KEYS = %w{time key}
    
    module Key
      def to_stream(cmd, opts)
        cmd[:key] = text_value
        if SETTING_KEYS.include?(text_value)
          cmd[:type] = :setting
          cmd[:ephemeral] = !NON_EPHEMERAL_KEYS.include?(cmd[:key])
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
  
  class VoiceSelector < Root
    def to_stream(stream, opts)
      voice = (text_value =~ /^([1234])/) && $1.to_i
      stream << {type: :voice_select, voice: voice}
    end
  end
  
  class SourceRef < Root
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
  
  module Repeat
    class Start < Root
      def to_stream(stream, opts)
        ref = {type: :repeat_start, raw: text_value, count: 2}
        if text_value =~ /(\d+)$/
          ref[:count] = $1.to_i
        end
        
        stream << event_hash(stream, opts, ref)
      end
    end
    
    class Volta < Root
      def to_stream(stream, opts)
        stream << event_hash(stream, opts, {
          type: :repeat_volta,
          raw:  text_value
        })
      end
    end

    class End < Root
      def to_stream(stream, opts)
        stream << event_hash(stream, opts, {
          type: :repeat_end,
          raw:  text_value
        })
      end
    end
  end
end
