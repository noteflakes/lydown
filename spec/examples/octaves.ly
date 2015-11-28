\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c'4 d, e''2 fis,,
    c'8 c16 d ees,,8 ees16 f
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
