\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket flute1 violino2 )
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
      >>
    }
  }
}
