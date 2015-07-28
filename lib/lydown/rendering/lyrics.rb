module Lydown::Rendering
  class Lyrics < Base
    def translate
      value = lilypond_lyrics(@event[:content])
      
      lyrics_idx = @event[:stream_index] || 1
      voice = @context['process/voice_selector'] || 'voice1'
      
      @context.emit("lyrics/#{voice}/#{lyrics_idx}", value, ' ')
    end

    def lilypond_lyrics(lyrics)
      lyrics.
        gsub(/_+/)  {|m| " __ #{'_ ' * (m.size - 1)}"}.
        gsub(/\-+/) {|m| " -- #{'_ ' * (m.size - 1)}"}
    end
  end
end
