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
        
        << \new Voice = "soprano_voice1" {
          c8 c g' g a' a g4
          f8 f e e d d c4 d8[ e f e] d2
        } >>
      }
    }
    \new Lyrics \lyricsto "soprano_voice1" {
      Twin -- kle twin -- kle lit -- tle star,
      How I won -- der what you are. __ _ _
    }
    >>
  }
}
