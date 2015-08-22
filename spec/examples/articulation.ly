\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c4 c-- c-. c-! c
    des'\f dis-.\trill
  } >>
}

\book {
  \header {
  }

  \score {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \ldMusic
    }
    >>
  }
}
