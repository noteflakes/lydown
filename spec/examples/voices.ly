\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
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
    }
    \new Lyrics \lyricsto "voice1" {
      Bin ich's?
      Nein ja nein ja
    }

    \new Lyrics \lyricsto "voice2" {
      Ja ja!
    }

    \new Lyrics \lyricsto "voice2" {
      Nei nei
    }
    >>
  }
}
