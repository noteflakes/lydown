\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c1
    b2 bes
  } >>
}
"//figures" = \figuremode { <_->2 <4+> <6> <6> }

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
      \new FiguredBass { \"//figures" }
      >>
    }
  }
}
