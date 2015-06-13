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
        << \new Voice = "soprano_voice1" {
          \autoBeamOff
          c8 c g' g a' a g4
          f8 f e e d d c4 d8[ e f e] d2
        } >>
      }
    }
    \new Lyrics {
      \lyricsto "soprano_voice1" {
        Twin -- kle twin -- kle lit -- tle star,
        How I won -- der what you are. __ _ _
      }
    }
    \new Lyrics {
      \lyricsto "soprano_voice1" {
        When the blah blah shines up high,
        Then the blah blah blah blah sky. __ _ _
      }
    }
    >>
  }
}
