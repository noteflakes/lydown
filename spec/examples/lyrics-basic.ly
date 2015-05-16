\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = SopranoStaff \with { }
    \context Staff = SopranoStaff {
      \relative c {
        \clef "treble"
        \autoBeamOff
        c8 c g' g a' a g4
        f8 f e e d d c4 d8[ e f e] d2
      }
    }
    \addlyrics {
      Twin -- kle twin -- kle lit -- tle star,
      How I won -- der what you are. __ _ _
    }
    >>
  }
}
