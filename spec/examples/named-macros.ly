\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    a'8. g16[ f8] ees'
    c d16 e8 f16
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
