module Lydown::Rendering
  class Base
    def initialize(event, work, stream, idx)
      @event = event
      @work = work
      @stream = stream
      @idx = idx
    end
    
    def translate
      # do nothing by default
    end
    
    def next_event
      @stream[@idx + 1]
    end
  end
end