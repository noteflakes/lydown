\version "2.18.2"

"/viola/music" = \relative c {
  << \new Voice = "viola_voice1" {
   s1 R1*1
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
        \"/viola/music"
      }
      >>
    }
  }
}
