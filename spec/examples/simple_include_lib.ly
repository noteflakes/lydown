\version "2.18.2"

\include "lydown/lib.ly"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        << \new Voice = "voice1" {
          c4 e8 g c2
        } >>
        \bar "|."
      }
    }
    >>
  }
}
