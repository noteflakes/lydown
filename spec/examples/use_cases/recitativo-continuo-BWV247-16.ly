\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c1
    b2 bes
  } >>
}
ldFigures = \figuremode { <_->2 <4+> <6> <6> }

\book {
  \header {
  }

  \score {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \ldMusic
    }
    \new FiguredBass { \ldFigures }
    >>
  }
}
