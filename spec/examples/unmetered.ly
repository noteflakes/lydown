\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        \cadenzaOn
        c4 c d e | d d d d f f d | e c d
      }
    }
    >>
  }
}
