\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \tempo 4=96 
    c4 d e f 
    \tempo 4=120
    g a b c 
    \tempo 4=52
    d1
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
      \midi {  }
    }
  }
}
