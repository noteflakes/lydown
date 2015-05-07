\version "2.18.2"

\book {
  \header {
  }
  
  \new Staff = ViolinoIStaff \with { } 
  \context Staff = ViolinoIStaff {
    \relative c {
      \clef treble
      \time 3/8
      c'8 e g g4.
    }
  }
}