require 'lydown/core_ext'
require 'lydown/parser'
require 'lydown/templates'

module Lydown
  class Opus
    attr_accessor :context
    
    def initialize
      @context = {
        time:             '4/4',
        key:              'c major',
        duration_values:  ['4']
      }
      @context.deep = true
    end
    
    def compile(source)
      ast = LydownParser.new.parse(source)
      ast.compile(self)
    end
    
    def add_note(note)
      value = @context[:duration_values].first
      @context[:duration_values].rotate!
      music = ''
      
      # only add the value if different than the last used
      if value == @context[:last_value]
        value = ''
      else
        @context[:last_value] = value
      end
      add_music(note + value + ' ')
    end
    
    def add_music(music)
      current_stream(:music) << music
    end
    
    def current_stream(type)
      movement = @context[:current_movement]
      part = @context[:current_part]
      path = "movements/#{movement}/parts/#{part}/#{type}"
      @context[path] ||= ''
    end
    
    def to_lilypond(options = {})
      if options[:stream_path]
        @context[options[:stream_path]].strip
      else
        Lydown::Templates.render(:lilypond_doc, opus: self)
      end
    end
    
    def [](path)
      context[path]
    end
    
    def []=(path, value)
      context[path] = value
    end
  end
end