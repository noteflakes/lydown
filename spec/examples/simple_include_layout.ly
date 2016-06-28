\version "2.18.2"

\paper {
  #(set-paper-size "a4" 'portrait)
  #(layout-set-staff-size 17.0)
  %indent = 0\mm
  two-sided = ##t
  inner-margin = 12\mm
  outer-margin = 18\mm
  binding-offset = 0\mm
  top-margin = 10\mm
  bottom-margin = 10\mm
}

\setVerticalMargins 11.3 9.3 11.3

\layout {
  \context { \Score \remove "Bar_number_engraver" } 
}

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
