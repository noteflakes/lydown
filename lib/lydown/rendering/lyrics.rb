module Lydown::Rendering
  class Lyrics < Base
    def translate
      value = lilypond_lyrics(@event[:content])
      @opus.emit(:lyrics, value, ' ')
    end
    
    def lilypond_lyrics(lyrics)
      lyrics.
        gsub(/\-+/) {|m| " -- #{'_ ' * (m.size - 1)}"}.
        gsub(/_+/)  {|m| " __ #{'_ ' * (m.size - 1)}"}
    end
  end
end