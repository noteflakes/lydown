\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    \key d \major
    g'16 a b g e4 <fis d>2
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
