\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    \once \override Stem.details.beamed-lengths = #'(4 4 3)
    \override Stem.thickness = #5.0
    \override TextSpanner.bound-details.left.text = #"left text"
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
