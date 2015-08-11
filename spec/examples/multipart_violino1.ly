\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = ViolinoIStaff \with { }
    \context Staff = ViolinoIStaff {
      \set Score.skipBars = ##t 
      \relative c {
        \clef "treble"
        << \new Voice = "violino1_voice1" {
          \time 3/8
          c'8 e g g4.
        } >>
      }
    }
    >>
  }
}
