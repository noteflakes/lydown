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

    <<
    \new Staff = ViolinoIStaff \with { }
    \context Staff = ViolinoIStaff {
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
  }
}
