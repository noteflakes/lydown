\version "2.18.2"
\book {
  \header {
  }
  
  \new Staff = Staff \with { } 
  \context Staff = Staff {
    \relative c {
      c8 d e( f) g a( b c)

      d16-. e( fis d) e-. fis( g ees)
    }
  }
}