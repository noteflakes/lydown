\version "2.18.2"

"01-intro/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \key d \major \time 3/4
  } >>
}
"01-intro/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
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
        <<
          \"01-intro/global/music"
          \"01-intro/violino1/music"
        >>
        \bar "|."
      }
      >>
    }
  }
}
