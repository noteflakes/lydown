\version "2.18.2"

\include "spec/examples/abc.ly"
% Hello from template

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \include "spec/examples/jkl.ly"
    
    \score {
      \new StaffGroup << 
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar )
        <<
        \new Staff = Staff \with { }
        \context Staff = Staff {
          \set Staff.instrumentName = #""
          \"//music"
        }
        >>
      >>
    }
  }
}
