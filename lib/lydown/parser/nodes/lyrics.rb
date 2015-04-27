module Lydown::Parsing
  module LyricsNode
    def compile(opus)
      value = lilypond_lyrics(text_value)
      opus.emit(:lyrics, value, ' ')
    end
    
    def lilypond_lyrics(lyrics)
      lyrics.
        gsub(/\-+/) {|m| " -- #{'_ ' * (m.size - 1)}"}.
        gsub(/_+/)  {|m| " __ #{'_ ' * (m.size - 1)}"}
    end
  end
end