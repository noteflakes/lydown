\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \set Score.skipBars = ##t 
      \relative c {
        << \new Voice = "voice1" {
          c4 e8 g c2
        } >>
      }
    }
    >>
  }
}
