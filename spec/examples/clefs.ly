\version "2.18.2"

"//music" = \relative c {
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
