\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \clef "bass"
    c4 d e f
    \clef "alto"
    g a b c
    \clef "treble"
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \"/global/music"
      }
      >>
    }
  }
}
