\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \score {
    \new StaffGroup << 
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket )
      <<
        \new Staff = Staff \with { }
        \context Staff = Staff {
          \set Staff.instrumentName = #""
          \ldMusic
          \bar "|."
        }
      >>
    >>
    \midi { \tempo 4=75 }
  }
}
