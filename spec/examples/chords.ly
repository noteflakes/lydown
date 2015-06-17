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
          \key d \major
          g16 a b g e4 <fis d>2
        } >>
      }
    }
    >>
  }
}
