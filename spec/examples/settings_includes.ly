\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    a'4 b c d
  } >>
}


\book {
  \header {
  }

  \bookpart { 
    \include "abc.ly"
    \include "../def.ly"

    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \ldMusic
      }
      >>
    }
  }
}
