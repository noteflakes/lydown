require 'lydown/templates'
require 'lydown/renderer/opus'
require 'lydown/renderer/base'
require 'lydown/renderer/comments'
require 'lydown/renderer/lyrics'
require 'lydown/renderer/music'
require 'lydown/renderer/settings'

module Lydown::Rendering
  class << self
    def render_movement(name, movement)
      Lydown::Templates.render(:movement, name: name, movement: movement)
    end
    
    def render_part(name, part)
      Lydown::Templates.render(:part, name: name, part: part)
    end
    
    def translate(opus, e, lydown_stream, idx)
      begin
        klass = Lydown::Rendering.const_get(e[:type].capitalize)
        klass.new(e, opus, lydown_stream, idx).translate
      rescue => e
        raise e
        # raise LydownError, "Invalid lydown stream event: #{e.inspect}"
      end
    end
  end
  
  class Base
    def initialize(event, opus, stream, idx)
      @event = event
      @opus = opus
      @stream = stream
      @idx = idx
    end
  end
end