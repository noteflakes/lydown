module Lydown::Rendering
  # SourceRef does nothing, it's only there to provide line, column references
  # for notes in a macro group
  class SourceRef < Base
    def translate
      fn = @event[:filename]
      if fn && fn != @context['process/last_filename']
        @context['process/last_filename'] = fn

        return # unless @context['options/proof_mode']

        @context.emit(@event[:stream] || :music, "%{::#{File.expand_path(fn)}%} ")
      end
    end
  end
end
