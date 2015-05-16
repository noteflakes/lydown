module Lydown::Rendering
  class Lyrics < Base
    def translate
      value = lilypond_lyrics(@event[:content])
      @work.emit(@event[:stream] || :lyrics, value, ' ')
    end

    def lilypond_lyrics(lyrics)
      lyrics.
        gsub(/_+/)  {|m| " __ #{'_ ' * (m.size - 1)}"}.
        gsub(/\-+/) {|m| " -- #{'_ ' * (m.size - 1)}"}
    end
  end
end
