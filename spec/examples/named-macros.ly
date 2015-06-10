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
          a8. g16[ f8] ees'
          c d16 e8 f16
        } >>
      }
    }
    >>
  }
}
