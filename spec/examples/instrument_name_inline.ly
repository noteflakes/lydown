\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket flute1 violino2 continuo )
        <<
        \new Staff = FluteIStaff \with { }
        \context Staff = FluteIStaff {
          \relative c {
            << \new Voice = "flute1_voice1" {
              c4 d <>^\markup { \smallCaps { Flute I } } e f
            } >>
          }
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with {  }
        \context Staff = ViolinoIIStaff {
          \relative c {
            \clef "treble"
            << \new Voice = "violino2_voice1" {
              <>^\markup { \smallCaps { Violino II } } g'4 a b c
            } >>
          }
        }
        >>

        <<
        \new Staff = ContinuoStaff \with { 
          \override VerticalAxisGroup.remove-empty = ##f  
        }
        \context Staff = ContinuoStaff {
          \relative c {
            \clef "bass"
            << \new Voice = "continuo_voice1" {
              <>^\markup { \right-align \smallCaps { Continuo } } e4
            } >>
          }
        }
        >>
      >>
    }
  }
}
