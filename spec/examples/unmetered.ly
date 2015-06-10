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
        \cadenzaOn
        c4 c d e \bar "|" d d d d f f d \bar "|" e c d
        } >>
      }
    }
    >>
  }
}
