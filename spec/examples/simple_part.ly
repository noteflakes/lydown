\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \score {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \set Score.skipBars = ##t 
      \ldMusic
    }
    >>
  }
}
