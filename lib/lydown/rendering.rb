require 'lydown/templates'
require 'lydown/rendering/opus'
require 'lydown/rendering/base'
require 'lydown/rendering/comments'
require 'lydown/rendering/lyrics'
require 'lydown/rendering/music'
require 'lydown/rendering/settings'

module Lydown::Rendering
  class << self
    def render_movement(name, movement)
      Lydown::Templates.render(:movement, name: name, movement: movement)
    end
    
    def render_part(name, part)
      Lydown::Templates.render(:part, name: name, part: part)
    end
    
    def translate(opus, e, lydown_stream, idx)
      klass = class_for_event(e)
      klass.new(e, opus, lydown_stream, idx).translate
    end
    
    def class_for_event(e)
      Lydown::Rendering.const_get(e[:type].to_s.camelize)
    rescue
      raise LydownError, "Invalid lydown event: #{e.inspect}"
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