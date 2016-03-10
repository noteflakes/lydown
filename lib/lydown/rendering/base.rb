module Lydown::Rendering
  class Base
    def initialize(event, context, stream, idx)
      @event = event
      @context = context
      @stream = stream
      @idx = idx
    end

    def translate
      # do nothing by default
    end
    
    def prev_event
      idx = @idx - 1
      while idx >= 0
        e = @stream[idx]
        return e if e && e[:type] != :comment
        idx -= 1
      end
      nil
    end
    
    def find_prev_event(filter)
      prev = prev_event
      return nil unless prev
      
      filter.each do |k, v|
        return nil unless prev[k] == v
      end
      
      prev
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
