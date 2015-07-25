\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    \header {
      piece = \markup {
        \column {
          \fill-line {\bold \large "1. Intro - tacet"}

        }
      }
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

    <<
    \new Staff = ViolinoIIStaff \with { }
    \context Staff = ViolinoIIStaff {
      \relative c {
        \clef "treble"
        << \new Voice = "violino2_voice1" {
          \time 2/4
          \key bes \major
          g'4 f8 ees d2
        } >>
        \bar "|."
      }
    }
    >>
  }
}
