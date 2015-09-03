\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
  \cadenzaOn
  c4 c d e \bar "|" d d d d f f d \bar "|" e c d
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
