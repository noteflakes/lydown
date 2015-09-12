\version "2.18.2"

"/flute1/music" = \relative c {
  << \new Voice = "flute1_voice1" {
    c4 d e f
  } >>
}
"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    g'4 a b c
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar flute1 violino2 )
        <<
        \new Staff = FluteIStaff \with { }
        \context Staff = FluteIStaff {
          \set Staff.instrumentName = \markup { \smallCaps { Flute I } }
          \"/flute1/music"
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with {  }
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = \markup { \smallCaps { Violino II } }
          \clef "treble"
          \"/violino2/music"
        }
        >>
      >>
    }
  }
}
