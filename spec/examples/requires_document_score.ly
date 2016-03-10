\version "2.18.2"

\require "abc"
\require "def"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \require "ghi"
    
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
