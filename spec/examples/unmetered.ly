\version "2.18.2"

"//music" = \relative c {
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
