\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    a'4 b c d
  } >>
}


\book {
  \header {
  }

  \bookpart { 
    \include "spec/examples/abc.ly"
    \include "spec/def.ly"

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
