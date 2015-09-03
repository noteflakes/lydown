\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    \tempo 4=96 
    c4 d e f 
    \tempo 4=120
    g a b c 
    \tempo 4=52
    d1
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
      }
      >>
      \midi {  }
    }
  }
}
