\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    \time 4/4
    c4 d e f
    s1*1
    g4 a b c
    \time 3/4
    s2.*4
    c2.
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
      }
      >>
    }
  }
}
