\version "2.18.2"

"01-intro/violino1/music" = \relative c {
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
        piece = "1. Intro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIStaff \with { }
          \context Staff = ViolinoIStaff {
            \clef "treble"
            \"01-intro/violino1/music"
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
