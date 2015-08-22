\version "2.18.2"

ldViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}
ldViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 3/8
    r4. b''8 d g
  } >>
}

\book {
  \header {
  }

  \score {
    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket (SystemStartBrace violino1 violino2) )
      <<
      \new Staff = ViolinoIStaff \with { }
      \context Staff = ViolinoIStaff {
        \set Staff.instrumentName = #"Violino I"
        \clef "treble"
        \ldViolinoIMusic
      }
      >>

      <<
      \new Staff = ViolinoIIStaff \with { }
      \context Staff = ViolinoIIStaff {
        \set Staff.instrumentName = #"Violino II"
        \clef "treble"
        \ldViolinoIIMusic
      }
      >>
    >>
  }
}
