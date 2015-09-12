\version "2.18.2"

"/gamba1/music" = \relative c {
  << \new Voice = "gamba1_voice1" {
    c4 d e f g1
  } >>
}

\book {
  \header {
  }
  \bookpart { 
  }
  \bookpart { 
    \score {
        <<
        \new Staff = GambaIStaff \with { }
        \context Staff = GambaIStaff {
          \set Score.skipBars = ##t 
          \clef "alto"
          \"/gamba1/music"
          \bar "|."
        }
        >>
    }
  }
}
