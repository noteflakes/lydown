\version "2.18.2"

\paper {
  #(set-paper-size "a4" 'portrait)
  #(layout-set-staff-size 17.0)
}

\layout {
  
}

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \"//music"
        \bar "|."
      }
      >>
    }
  }
}
