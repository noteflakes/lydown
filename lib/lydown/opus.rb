require 'lydown/core_ext'
require 'lydown/parser'
require 'lydown/templates'

require 'pp'

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
      parser = LydownParser.new
      ast = parser.parse(source)
      unless ast
        puts "Faild to compile"
        puts parser.failure_reason
        puts "  #{source.lines[parser.failure_line - 1]}"
        puts " #{' ' * parser.failure_column}^"
      else
        ast.compile(self)
      end
    end
    
    def emit(stream, content)
      current_stream(stream) << content
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