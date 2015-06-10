\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \tempo "Allegretto"
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        << \new Voice = "voice1" {
          c4 d e f
        } >>
      }
    }
    >>
  }
}
