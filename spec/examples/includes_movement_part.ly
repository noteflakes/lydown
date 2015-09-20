\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \include "spec/examples/abc.ly"
    % Hello from template
    \include "spec/examples/def.ly"
    \include "spec/examples/ghi.ly"

    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \set Score.skipBars = ##t
        \"//music"
      }
      >>
    }
  }
}
