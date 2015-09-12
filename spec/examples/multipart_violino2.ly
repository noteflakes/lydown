\version "2.18.2"

"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 3/8
    r4. b''8 d g
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = ViolinoIIStaff \with { }
      \context Staff = ViolinoIIStaff {
        \set Score.skipBars = ##t 
        \clef "treble"
        \"/violino2/music"
      }
      >>
    }
  }
}
