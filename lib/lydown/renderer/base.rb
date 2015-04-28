module Lydown::Rendering
  class Base
    def initialize(event, opus, stream, idx)
      @event = event
      @opus = opus
      @stream = stream
      @idx = idx
    end
    
    def translate
      # do nothing by default
    end
  end
end