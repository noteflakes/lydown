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
      idx = @idx + 1
      while idx < @stream.size
        e = @stream[idx]
        return e if e && e[:type] != :comment
        idx += 1
      end
      nil
    end
  end
end
