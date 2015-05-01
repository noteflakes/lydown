require 'lydown/templates'
require 'lydown/work'
require 'lydown/rendering/base'
require 'lydown/rendering/comments'
require 'lydown/rendering/lyrics'
require 'lydown/rendering/music'
require 'lydown/rendering/settings'

module Lydown::Rendering
  class << self
    def render_movement(name, movement, opts = {})
      Lydown::Templates.render(:movement, name: name, movement: movement, opts: opts)
    end
    
    def render_part(name, part, opts = {})
      Lydown::Templates.render(:part, name: name, part: part, opts: opts)
    end
    
    def translate(work, e, lydown_stream, idx)
      klass = class_for_event(e)
      klass.new(e, work, lydown_stream, idx).translate
    end
    
    def class_for_event(e)
      Lydown::Rendering.const_get(e[:type].to_s.camelize)
    rescue
      raise LydownError, "Invalid lydown event: #{e.inspect}"
    end
  end
  
  class Base
    def initialize(event, work, stream, idx)
      @event = event
      @work = work
      @stream = stream
      @idx = idx
    end
  end
end