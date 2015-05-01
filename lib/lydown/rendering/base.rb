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
  end
end