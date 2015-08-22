\version "2.18.2"

ldFluteIMusic = \relative c {
  << \new Voice = "flute1_voice1" {
    c4 d e f
  } >>
}
ldViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
    g'4 a b c
  } >>
}

\book {
  \header {
  }

  \score {
    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket flute1 violino2 )
      <<
      \new Staff = FluteIStaff \with { }
      \context Staff = FluteIStaff {
        \set Staff.instrumentName = \markup { \smallCaps { Flute I } }
        \ldFluteIMusic
      }
      >>

      <<
      \new Staff = ViolinoIIStaff \with {  }
      \context Staff = ViolinoIIStaff {
        \set Staff.instrumentName = \markup { \smallCaps { Violino II } }
        \clef "treble"
        \ldViolinoIIMusic
      }
      >>
    >>
  }
}
