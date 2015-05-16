\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        c4 c-- c-. c-! c
        des'\f dis-.\trill
      }
    }
    >>
  }
}
