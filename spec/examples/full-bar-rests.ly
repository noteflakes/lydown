\version "2.18.2"

\book {
  \header {
  }
  
  \bookpart {
    \new Staff = Staff \with { } 
    \context Staff = Staff {
      \relative c {
        \time 4/4
        c4 d e f
        R1*4/4
        g a b c
        \time 3/4
        R4*3/4
        c2.
      }
    }
  }
}