\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 \tuplet 3/2 4 { d8 e f g f e } d4

    \tuplet 5/4 2 { c8 d e f g }
    
    \tuplet 3/2 8 { e16 d e f e f }
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
