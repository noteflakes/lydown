\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        << \new Voice = "voice1" {
          c8 d e( f) g a( b c)

          d16-. e( fis d) e-. fis( g ees)
        } >>
      }
    }
    >>
  }
}
