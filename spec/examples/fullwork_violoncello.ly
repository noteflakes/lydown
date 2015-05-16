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
    \new Staff = VioloncelloStaff \with { }
    \context Staff = VioloncelloStaff {
      \relative c {
        \clef "bass"
        \time 3/4
        \key d \major
        d8 cis b a gis4
        \bar "|."
      }
    }
    >>
  }

  \bookpart {
    \header {
      piece = \markup {
        \column {
          \fill-line {\bold \large "2. Outro - tacet"}

        }
      }
    }
  }
}
