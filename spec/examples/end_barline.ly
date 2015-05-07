\version "2.18.2"
\book {
  \header {
  }
  
  \new Staff = Staff \with { } 
  \context Staff = Staff {
    \relative c {
      \clef treble
      c4 d e f
      \bar "||"
    }
  }
}