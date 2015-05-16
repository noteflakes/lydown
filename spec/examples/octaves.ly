\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        c'4 d, e''2 fis,,
        c'8 c16 d ees,,8 ees16 f
      }
    }
    >>
  }
}
