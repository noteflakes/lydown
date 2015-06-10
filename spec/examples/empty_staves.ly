\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    \score {
      \layout {
        \context {
          \RemoveEmptyStaffContext
          \override VerticalAxisGroup #'remove-first = ##t
        }
      }      
      
      
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket )
        <<
        \new Staff = Staff \with { }
        \context Staff = Staff {
          \set Staff.instrumentName = #""
          \relative c {
            << \new Voice = "voice1" {
              c4 e g c
            } >>
          }
        }
        >>
      >>
    }
  }
}
