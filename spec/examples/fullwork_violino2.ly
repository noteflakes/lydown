\version "2.18.2"

"02-outro/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4
    \key bes \major
    g'4 f8 ees d2
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \header {
        piece = "1. Intro - tacet"
      }
      \tacetScore
    }
    \score {
      \header {
        piece = "2. Outro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIIStaff \with { }
          \context Staff = ViolinoIIStaff {
            \clef "treble"
            \"02-outro/violino2/music"
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
