\version "2.18.2"

ldIintroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/4 \key d \major a'8 b cis d e4
  } >>
}
ldIintroVioloncelloMusic = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/4 \key d \major d8 cis b a gis4
  } >>
}
ldIIoutroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 2/4 \key bes \major ees4 f8 g a2
  } >>
}
ldIIoutroViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4 \key bes \major g'4 f8 ees d2
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
          \ldIIoutroViolinoIMusic
          \bar "|."
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with { }
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = #"Violino II"
          \clef "treble"
          \ldIIoutroViolinoIIMusic
          \bar "|."
        }
        >>
      >>
    }
  }
}
