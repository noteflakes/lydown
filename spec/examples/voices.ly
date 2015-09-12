\version "2.18.2"

"//music" = \relative c {
  <<
    \new Voice = "voice1" {
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
"//lyrics/voice1/1" = \lyricmode {
  Bin ich's?
  Nein ja nein ja
}
"//lyrics/voice2/1" = \lyricmode {
  Ja ja!
}
"//lyrics/voice2/2" = \lyricmode {
  Nei nei
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \"//music"
      }
      \new Lyrics \with { alignAboveContext = "Staff" } {
        \lyricsto "voice1" { \"//lyrics/voice1/1" }
      }

      \new Lyrics {
        \lyricsto "voice2" { \"//lyrics/voice2/1" }
      }

      \new Lyrics {
        \lyricsto "voice2" { \"//lyrics/voice2/2" }
      }
      >>
    }
  }
}
