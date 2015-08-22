\version "2.18.2"

ldViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

\book {
  \header {
  }

  \score {
    <<
    \new Staff = ViolinoIStaff \with { }
    \context Staff = ViolinoIStaff {
      \set Score.skipBars = ##t 
      \clef "treble"
      \ldViolinoIMusic
    }
    >>
  }
}
