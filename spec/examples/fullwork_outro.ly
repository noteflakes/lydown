\version "2.18.2"

\book {
  \header {
  }
  
  \bookpart {
    \header { 
      piece = \markup {
        \column {
          \fill-line {\bold \large "2. Outro"}
          
        }
      }
    }

    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket (SystemStartBrace violino1 violino2) )
        \new Staff = ViolinoIStaff \with { } 
        \context Staff = ViolinoIStaff {
          \set Staff.instrumentName = #"Violino I"
          \relative c {
            \clef treble
            \time 2/4
            \key bes \major
            ees4 f8 g a2
            \bar "|."
          }
        }

        \new Staff = ViolinoIIStaff \with { } 
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = #"Violino II"
          \relative c {
            \clef treble
            \time 2/4
            \key bes \major
            g4 f8 ees d2
            \bar "|."
          }
        }
      >>
    }
  }
}