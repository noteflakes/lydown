\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    \time 4/4
    c4 d e f
    R1*1
    g4 a b c
    R1*1^\markup { \italic { blah } }
    \time 3/4
    R2.*4
    c2.
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
