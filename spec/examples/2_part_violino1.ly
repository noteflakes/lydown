\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/8
  } >>
}

"/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
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
        <<
          \"/global/music"
          \"/violino1/music"
        >>
      }
      >>
    }
  }
}
