module Lydown::Rendering
  class Lyrics < Base
    def translate
      value = lilypond_lyrics(@event[:content])
      
      # The lyrics index is used to provide multiple lyrics for the same music.
      lyrics_idx = @event[:stream_index] || 1
      @work.emit("lyrics/#{lyrics_idx}", value, ' ')
    end

    def lilypond_lyrics(lyrics)
      lyrics.
        gsub(/_+/)  {|m| " __ #{'_ ' * (m.size - 1)}"}.
        gsub(/\-+/) {|m| " -- #{'_ ' * (m.size - 1)}"}
    end
  end
end
