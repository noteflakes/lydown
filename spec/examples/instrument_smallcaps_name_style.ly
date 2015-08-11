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
          \set Staff.instrumentName = \markup { \smallCaps { Flute I } }
          \relative c {
            << \new Voice = "flute1_voice1" {
              c4 d e f
            } >>
          }
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with {  }
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = \markup { \smallCaps { Violino II } }
          \relative c {
            \clef "treble"
            << \new Voice = "violino2_voice1" {
              g'4 a b c
            } >>
          }
        }
        >>
      >>
    }
  }
}
