\version "2.18.2"

"/global/music" = \relative c {
  <<
    \new Voice = "global_voice1" {
      R1*1
      
      <<
        {
          \voiceOne
          r4 e' g r
        }

        \new Voice = "voice2" {
          \voiceTwo
          c2 b4 r
        }
      >>
    
      \oneVoice
      R1*2
      c4 b a g
    }
  >>
}
"/global/lyrics/voice1/1" = \lyricmode {
  Bin ich's?
  Nein ja nein ja
}
"/global/lyrics/voice2/1" = \lyricmode {
  Ja ja!
}
"/global/lyrics/voice2/2" = \lyricmode {
  Nei nei
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \"/global/music"
      }
      \new Lyrics \with { alignAboveContext = "GlobalStaff" } {
        \lyricsto "global_voice1" { \"/global/lyrics/voice1/1" }
      }

      \new Lyrics {
        \lyricsto "global_voice2" { \"/global/lyrics/voice2/1" }
      }

      \new Lyrics {
        \lyricsto "global_voice2" { \"/global/lyrics/voice2/2" }
      }
      >>
    }
  }
}
