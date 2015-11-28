\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/4
    \key d \major
  } >>
}

"/flute1/music" = \relative c {
  << \new Voice = "flute1_voice1" {
    d'4 fis a g2.
  } >>
}

"/flute2/music" = \relative c {
  << \new Voice = "flute2_voice1" {
    fis'4 a d b2.
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar (SystemStartBrace flute1 flute2) )
        <<
        \new Staff = FluteIStaff \with { }
        \context Staff = FluteIStaff {
          \set Staff.instrumentName = #"Flute I"
          \clef "treble"
          <<
            \"/global/music"
            \"/flute1/music"
          >>
          \bar "|."
        }
        >>

        <<
        \new Staff = FluteIIStaff \with { }
        \context Staff = FluteIIStaff {
          \set Staff.instrumentName = #"Flute II"
          \clef "treble"
          <<
            \"/global/music"
            \"/flute2/music"
          >>
          \bar "|."
        }
        >>
      >>
    }
  }
}
