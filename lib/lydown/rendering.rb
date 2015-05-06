require 'lydown/templates'
require 'lydown/work'
require 'lydown/rendering/base'
require 'lydown/rendering/comments'
require 'lydown/rendering/lyrics'
require 'lydown/rendering/music'
require 'lydown/rendering/settings'

require 'yaml'

module Lydown::Rendering
  DEFAULTS = YAML.load(IO.read(File.join(File.dirname(__FILE__), 'rendering/defaults.yml')))
  
  class << self
    def translate(work, e, lydown_stream, idx)
      klass = class_for_event(e)
      klass.new(e, work, lydown_stream, idx).translate
    end
    
    def class_for_event(e)
      Lydown::Rendering.const_get(e[:type].to_s.camelize)
    rescue
      raise LydownError, "Invalid lydown event: #{e.inspect}"
    end
    
    def part_title(part_name)
      if part_name =~ /^([^\d]+)(\d+)$/
        "#{$1.titlize} #{$2.to_i.to_roman}"
      else
        part_name.titlize
      end
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