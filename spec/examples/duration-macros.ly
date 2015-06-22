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
          c c c c d d d d R1*1
          d16(\p c) d( b)
        } >>
      }
    }
    >>
  }
}
