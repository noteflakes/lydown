\version "2.18.2"

ldIintroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/4
    \key bes \major
    a'4 bes c d
    \key d \major
    a b cis d
  } >>
}
ldIintroVioloncelloMusic = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/4
    \key bes \major
    ees4 f g a
    \key d \major
    e fis g a
  } >>
}
ldIIoutroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 2/4
    \key bes \major
    a'4 bes
    \time 5/4
    c d
  } >>
}
ldIIoutroViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4
    \key bes \major
    ees4 f
    \time 5/4
    g a
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
          \partial 8
          \ldIintroViolinoIMusic
          \bar "|."
        }
        >>

        <<
        \new Staff = VioloncelloStaff \with { }
        \context Staff = VioloncelloStaff {
          \set Staff.instrumentName = #"Violoncello"
          \clef "bass"
          \partial 8
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
