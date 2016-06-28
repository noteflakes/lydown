\version "2.18.2"

\pinclude "lydown/lib.ly"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
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
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
