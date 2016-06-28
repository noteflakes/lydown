\version "2.18.2"

"01-intro/violoncello/music" = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/4
    \key d \major
    d8 cis b a gis4
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
          \new Staff = VioloncelloStaff \with { }
          \context Staff = VioloncelloStaff {
            \clef "bass"
            \"01-intro/violoncello/music"
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }

    \score {
      \header {
        piece = "2. Outro - tacet"
      }
      \tacetScore
    }

  }
}
