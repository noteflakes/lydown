\version "2.18.2"

\book {
  \header {
  }
  
  \new Staff = Staff \with { } 
  \context Staff = Staff {
    \relative c {
      c4 d8 e16 f32 g a4 b

      c8. d16 e8. f16 g2

      r16.. c32 r16 f r c r f
    }
  }
}