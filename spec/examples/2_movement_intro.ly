\version "2.18.2"

"01-intro//music" = \relative c {
  << \new Voice = "voice1" {
    \time 3/8
    \key c \minor
    c'8 ees g g4.
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \header {
        piece = \markup { \bold \large { 1. Intro } }
      }

      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \"01-intro//music"
      }
      >>
    }
  }
}
