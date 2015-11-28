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
"02-outro/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \key bes \major \time 2/4 
  } >>
}
"02-outro/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    ees4 f8 g a2
  } >>
}
"02-outro/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    g'4 f8 ees d2
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

    \score {
      \header {
        piece = \markup { \bold \large { 2. Outro } }
      }

      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar (SystemStartBrace violino1 violino2) )
        <<
        \new Staff = ViolinoIStaff \with { }
        \context Staff = ViolinoIStaff {
          \set Staff.instrumentName = #"Violino I"
          \clef "treble"
          <<
            \"02-outro/global/music"
            \"02-outro/violino1/music"
          >>
          \bar "|."
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with { }
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = #"Violino II"
          \clef "treble"
          <<
            \"02-outro/global/music"
            \"02-outro/violino2/music"
          >>
          \bar "|."
        }
        >>
      >>
    }
  }
}
