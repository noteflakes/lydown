\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 e g c
  } >>
}

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
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar global )
        <<
        \new Staff = GlobalStaff \with { }
        \context Staff = GlobalStaff {
          \set Staff.instrumentName = #""
          \"/global/music"
        }
        >>
      >>
    }
  }
}
