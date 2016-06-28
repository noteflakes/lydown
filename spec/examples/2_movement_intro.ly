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
        piece = "1. Intro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \"01-intro//music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
