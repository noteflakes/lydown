\version "2.18.2"

ldIintroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/4
    \key d \major
    a'8 b cis d e4
  } >>
}
ldIintroVioloncelloMusic = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/4
    \key d \major
    d8 cis b a gis4
  } >>
}

\book {
  \header {
  }

  \score {
    \header {
      piece = \markup {
        \column {
          \fill-line {\bold \large "1. Intro"}

        }
      }
    }

    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket violino1 violoncello )
      <<
      \new Staff = ViolinoIStaff \with { }
      \context Staff = ViolinoIStaff {
        \set Staff.instrumentName = #"Violino I"
        \clef "treble"
        \ldIintroViolinoIMusic
        \bar "|."
      }
      >>

      <<
      \new Staff = VioloncelloStaff \with { }
      \context Staff = VioloncelloStaff {
        \set Staff.instrumentName = #"Violoncello"
        \clef "bass"
        \ldIintroVioloncelloMusic
        \bar "|."
      }
      >>
    >>
  }
}
