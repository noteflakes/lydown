\version "2.18.2"

\book {
  \header {
  }
  
  \new Staff = ViolinoIIStaff \with { } 
  \context Staff = ViolinoIIStaff {
    \relative c {
      \clef treble
      \time 3/8
      r4. b'8 d g
    }
  }
}