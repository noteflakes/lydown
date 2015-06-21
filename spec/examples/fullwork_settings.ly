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
            \partial 8
            << \new Voice = "violino1_voice1" {
              \time 3/4
              \key bes \major
              a4 bes c d
              \key d \major
              a b cis d
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
            \partial 8
            << \new Voice = "violoncello_voice1" {
              \time 3/4
              \key bes \major
              ees4 f g a
              \key d \major
              e fis g a
            } >>
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
            << \new Voice = "violino1_voice1" {
              \time 2/4
              \key bes \major
              a4 bes
              \time 5/4
              c d
            } >>
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
            << \new Voice = "violino2_voice1" {
              \time 2/4
              \key bes \major
              ees4 f
              \time 5/4
              g a
            } >>
            \bar "|."
          }
        }
        >>
      >>
    }
  }
}
