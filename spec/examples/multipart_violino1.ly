\version "2.18.2"

"/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = ViolinoIStaff \with { }
      \context Staff = ViolinoIStaff {
        \set Score.skipBars = ##t 
        \clef "treble"
        \"/violino1/music"
      }
      >>
    }
  }
}
