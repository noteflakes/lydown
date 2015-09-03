\version "2.18.2"

ldIintroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/4
    \key d \major
    a'8 b cis d e4
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \header {
        piece = \markup { \bold \large { 1. Intro } }
      }

      <<
      \new Staff = ViolinoIStaff \with { }
      \context Staff = ViolinoIStaff {
        \clef "treble"
        \ldIintroViolinoIMusic
        \bar "|."
      }
      >>
    }
  }
}
