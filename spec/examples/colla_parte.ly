\version "2.18.2"

ldViolaMusic = \relative c {
  << \new Voice = "viola_voice1" {
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
      \new Staff = ViolaStaff \with { }
      \context Staff = ViolaStaff {
        \set Score.skipBars = ##t 
        \clef "alto"
        \ldViolaMusic
      }
      >>
    }
  }
}
