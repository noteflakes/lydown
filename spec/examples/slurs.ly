\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c8 d e( f) g a( b c)

    d16-. e( fis d) e-. fis( g ees)
    
    d(\p c) d( b)
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
