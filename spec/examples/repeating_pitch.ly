\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    cis'4 ~ cis ges2
    ges16-- ges ges ges
    c4 d8 ees,4 ees8
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
