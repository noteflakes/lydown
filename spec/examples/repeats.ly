\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    R1*4
    \repeat volta 2 {
      c1 d
    } \alternative {
      { e f }
      { g a }
    }
    b c
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \"//music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
