\version "2.18.2"

\include "lydown/lib.ly"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \ldMusic
        \bar "|."
      }
      >>
    }
  }
}
