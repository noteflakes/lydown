\version "2.18.2"

\book {
  \header {
  }
  
  \score {
    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket (SystemStartBrace violino1 violino2) )
      \new Staff = ViolinoIStaff \with { } 
      \context Staff = ViolinoIStaff {
        \set Staff.instrumentName = #"Violino I"
        \relative c {
          \time 3/8
          c'8 e g g4.
        }
      }

      \new Staff = ViolinoIIStaff \with { } 
      \context Staff = ViolinoIIStaff {
        \set Staff.instrumentName = #"Violino II"
        \relative c {
          \time 3/8
          r4. b'8 d g
        }
      }
    >>
  }
}