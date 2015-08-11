\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = ViolinoIIStaff \with { }
    \context Staff = ViolinoIIStaff {
      \set Score.skipBars = ##t 
      \relative c {
        \clef "treble"
        << \new Voice = "violino2_voice1" {
          \time 3/8
          r4. b''8 d g
        } >>
      }
    }
    >>
  }
}
