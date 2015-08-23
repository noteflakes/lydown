\version "2.18.2"

ldIIoutroViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4
    \key bes \major
    g'4 f8 ees d2
  } >>
}

\book {
  \header {
  }

  \score {
    \header {
      piece = \markup { \bold \large { 1. Intro - tacet } }
    }
  }

  \score {
    \header {
      piece = \markup { \bold \large { 2. Outro } }
    }

    <<
    \new Staff = ViolinoIIStaff \with { }
    \context Staff = ViolinoIIStaff {
      \clef "treble"
      \ldIIoutroViolinoIIMusic
      \bar "|."
    }
    >>
  }
}
