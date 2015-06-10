\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        \partial 8
        << \new Voice = "voice1" {
          b8
          c4 e8 g c2
        } >>
      }
    }
    >>
  }
}
