\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
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
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \ldMusic
      }
      >>
    }
  }
}
