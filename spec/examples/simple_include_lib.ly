\version "2.18.2"

\include "lydown/lib.ly"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 e8 g c2
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
        \bar "|."
      }
      >>
    }
  }
}
