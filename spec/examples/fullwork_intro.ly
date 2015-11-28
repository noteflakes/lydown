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
"01-intro/violoncello/music" = \relative c {
  << \new Voice = "violoncello_voice1" {
    d8 cis b a gis4
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

      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar violino1 violoncello )
        <<
        \new Staff = ViolinoIStaff \with { }
        \context Staff = ViolinoIStaff {
          \set Staff.instrumentName = #"Violino I"
          \clef "treble"
          <<
            \"01-intro/global/music"
            \"01-intro/violino1/music"
          >>
          \bar "|."
        }
        >>

        <<
        \new Staff = VioloncelloStaff \with { }
        \context Staff = VioloncelloStaff {
          \set Staff.instrumentName = #"Violoncello"
          \clef "bass"
          <<
            \"01-intro/global/music"
            \"01-intro/violoncello/music"
          >>
          \bar "|."
        }
        >>
      >>
    }
  }
}
