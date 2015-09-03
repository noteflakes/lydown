\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    \clef "bass"
    c4 d e f
    \clef "alto"
    g a b c
    \clef "treble"
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
