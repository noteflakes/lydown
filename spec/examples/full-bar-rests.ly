\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 4/4
    c4 d e f
    R1*1
    g4 a b c
    R1*1^\markup { \italic { blah } }
    \time 3/4
    R2.*4
    c2.
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
