require 'lydown/core_ext'
require 'lydown/templates'

require 'pp'

module Lydown
  # Work is a virtual lilypond document. It can contain multiple movements,
  # and each movement can contain multiple parts. Each part can contain multiple
  # streams: music, lyrics, figured bass.
  # 
  # A Work instance is created in order to translate lydown code into a 
  # virtual lilypond document, and then render it. The actual rendering may
  # include all of the streams in the document, or only a selection,such as a
  # specific movement, a specific part, or a specific stream type.
  class Work
    attr_accessor :context
    
    def initialize
      @context = {}.deep!
      @context[:time] = '4/4'
      @context[:key] = 'c major'
      @context['process/duration_values'] = ['4']
    end
    
    # translate a lydown stream into lilypond
    def process(lydown_stream)
      lydown_stream.each_with_index do |e, idx|
        if e[:type]
          Lydown::Rendering.translate(self, e, lydown_stream, idx)
        else
          raise LydownError, "Invalid lydown stream event: #{e.inspect}"
        end
      end
    end
    
    def emit(stream_type, *content)
      stream = current_stream(stream_type)
      content.each {|c| stream << c}
    end
    
    def current_stream(type)
      movement = @context[:movement]
      part = @context[:part]
      path = "movements/#{movement}/parts/#{part}/#{type}"
      @context[path] ||= ''
    end
    
    def to_lilypond(opts = {})
      ly_code = ''
      if opts[:stream_path]
        @context[opts[:stream_path]].strip
      else
        @original_context = @context
        @context = filter_context(opts)
        ly = Lydown::Templates.render(:lilypond_doc, work: self)
        @context = @original_context
        ly
      end
    end
    
    def filter_context(opts = {})
      filtered = @context.deep_clone
      filtered.deep = true
      if opts[:movements]
        opts[:movements] = [opts[:movements]] unless opts[:movements].is_a?(Array)
        filtered['movements'].select! do |name, m|
          opts[:movements].include?(name.to_s)
        end
      end
      
      if opts[:parts]
        opts[:parts] = [opts[:parts]] unless opts[:parts].is_a?(Array)
      end
      filtered['movements'].each do |name, m|
        if opts[:parts]
          m['parts'].select! do |pname, p|
            opts[:parts].include?(pname.to_s)
          end
        end
      end
      
      filtered
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