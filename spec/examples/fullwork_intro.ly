\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    \header {
      piece = \markup {
        \column {
          \fill-line {\bold \large "1. Intro"}

        }
      }
    }

    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket violino1 violoncello )
        <<
        \new Staff = ViolinoIStaff \with { }
        \context Staff = ViolinoIStaff {
          \set Staff.instrumentName = #"Violino I"
          \relative c {
            \clef "treble"
            << \new Voice = "violino1_voice1" {
              \time 3/4
              \key d \major
              a8 b cis d e4
            } >>
            \bar "|."
          }
        }
        >>

        <<
        \new Staff = VioloncelloStaff \with { }
        \context Staff = VioloncelloStaff {
          \set Staff.instrumentName = #"Violoncello"
          \relative c {
            \clef "bass"
            << \new Voice = "violoncello_voice1" {
              \time 3/4
              \key d \major
              d8 cis b a gis4
            } >>
            \bar "|."
          }
        }
        >>
      >>
    }
  }
}
