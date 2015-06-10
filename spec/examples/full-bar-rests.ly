\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        << \new Voice = "voice1" {
          \time 4/4
          c4 d e f
          R1*1
          g a b c
          \time 3/4
          R2.*4
          c2.
        } >>
      }
    }
    >>
  }
}
