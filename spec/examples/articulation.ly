\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 c-- c-. c-! c
    des'\f dis-.\trill
    e-._\editP
    fisis-.^\editF
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
