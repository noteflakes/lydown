\version "2.18.2"

\book {
  \header {
  }
  
  \new Staff = Staff \with { } 
  \context Staff = Staff {
    \relative c {
      \time 3/8
      r4. b'8 d g
    }
  }
}