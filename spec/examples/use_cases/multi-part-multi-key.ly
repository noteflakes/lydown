\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = ViolinoIStaff \with { }
    \context Staff = ViolinoIStaff {
      \relative c {
        \clef "treble"
        \key fis \minor fis1
        \key d \minor f
      }
    }
    >>

    <<
    \new Staff = ContinuoStaff \with { }
    \context Staff = ContinuoStaff {
      \relative c {
        \clef "bass"
        \key fis \minor cis1
        \key d \minor c
      }
    }
    >>
  }
}