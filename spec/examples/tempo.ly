\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \tempo "Allegretto"
      \relative c {
        << \new Voice = "voice1" {
          c4 d e f
        } >>
      }
    }
    >>
  }
}
