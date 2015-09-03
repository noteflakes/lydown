\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c'4 d, e''2 fis,,
    c'8 c16 d ees,,8 ees16 f
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
        \ldMusic
      }
      >>
    }
  }
}
