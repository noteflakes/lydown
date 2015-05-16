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
            \time 3/4
            \key d \major
            a8 b cis d e4
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
            \time 3/4
            \key d \major
            d8 cis b a gis4
            \bar "|."
          }
        }
        >>
      >>
    }
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
        <<
        \new Staff = ViolinoIStaff \with { }
        \context Staff = ViolinoIStaff {
          \set Staff.instrumentName = #"Violino I"
          \relative c {
            \clef "treble"
            \time 2/4
            \key bes \major
            ees4 f8 g a2
            \bar "|."
          }
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with { }
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = #"Violino II"
          \relative c {
            \clef "treble"
            \time 2/4
            \key bes \major
            g4 f8 ees d2
            \bar "|."
          }
        }
        >>
      >>
    }
  }
}
