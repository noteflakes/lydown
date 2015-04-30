require 'lydown/core_ext'
require 'lydown/templates'

require 'pp'

module Lydown
  # Opus is a virtual lilypond document. It can contain multiple movements,
  # and each movement can contain multiple parts. Each part can contain multiple
  # streams: music, lyrics, figured bass.
  # 
  # An Opus instance is created in order to translate lydown code into a 
  # virtual lilypond document, and then render it. The actual rendering may
  # include all of the streams in the document, or only a selection,such as a
  # specific movement, a specific part, or a specific stream type.
  class Opus
    attr_accessor :context
    
    def initialize
      @context = {}.deep!
      @context[:time] = '4/4'
      @context[:key] = 'c major'
      @context['translate/duration_values'] = ['4']
    end
    
    # translate a lydown stream into a lilypond document
    def process(lydown_stream)
      lydown_stream.each_with_index do |e, idx|
        if e[:type]
          Lydown::Rendering.translate(self, e, lydown_stream, idx)
        else
          raise LydownError, "Invalid lydown stream event: #{e.inspect}"
        end
      end
    end
    
    def emit(stream, *content)
      stream = current_stream(stream)
      content.each {|c| stream << c}
    end
    
    def current_stream(type)
      movement = @context[:current_movement]
      part = @context[:current_part]
      path = "movements/#{movement}/parts/#{part}/#{type}"
      @context[path] ||= ''
    end
    
    def to_lilypond(opts = {})
      ly_code = ''
      if opts[:stream_path]
        @context[opts[:stream_path]].strip
      else
        Lydown::Templates.render(:lilypond_doc, opus: self)
      end
    end
    
    def compile(opts = {})
      code = to_lilypond(opts)
      
      Lydown::Lilypond.compile(code, opts)
    end
    
    def [](path)
      context[path]
    end
    
    def []=(path, value)
      context[path] = value
    end
  end
end