\version "2.18.2"

ldGambaIMusic = \relative c {
  << \new Voice = "gamba1_voice1" {
    c4 d e f g1
  } >>
}

\book {
  \header {
  }
  \pageBreak
  \score {
      <<
      \new Staff = GambaIStaff \with { }
      \context Staff = GambaIStaff {
        \set Score.skipBars = ##t 
        \clef "alto"
        \ldGambaIMusic
        \bar "|."
      }
      >>
  }
}
