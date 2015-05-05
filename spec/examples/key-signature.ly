\version "2.18.2"
\book {
  \header {
  }
  
  \new Staff = Staff \with { } 
  \context Staff = Staff {
    \relative c {
      \key c \major
      c4 d e f
      \key a \minor
      g a b c
      \key ees \major
      \key fis \minor
    }
  }
}