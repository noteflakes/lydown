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
          c4 \tuplet 3/2 4 { d8 e f g f e } d4

          \tuplet 5/4 2 { c8 d e f g }
        } >>
      }
    }
    >>
  }
}
