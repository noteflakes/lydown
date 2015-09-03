\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c4 d e f
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
        \bar "||"
      }
      >>
    }
  }
}
