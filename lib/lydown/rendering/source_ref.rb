module Lydown::Rendering
  # SourceRef does nothing, it's only there to provide line, column references
  # for notes in a macro group
  class SourceRef < Base
    def translate
      return # unless @work['options/proof_mode']

      fn = @event[:filename]
      if fn && fn != @work['process/last_filename']
        @work['process/last_filename'] = fn
        @work.emit(@event[:stream] || :music, "%{::#{File.expand_path(fn)}%} ")
      end
    end
  end
end
