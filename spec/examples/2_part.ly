\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/8
  } >>
}

"/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    c'8 e g g4.
  } >>
}
"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    r4. b''8 d g
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar (SystemStartBrace violino1 violino2) )
        <<
        \new Staff = ViolinoIStaff \with { }
        \context Staff = ViolinoIStaff {
          \set Staff.instrumentName = #"Violino I"
          \clef "treble"
          <<
            \"/global/music"
            \"/violino1/music"
          >>
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with { }
        \context Staff = ViolinoIIStaff {
          \set Staff.instrumentName = #"Violino II"
          \clef "treble"
          <<
            \"/global/music"
            \"/violino2/music"
          >>
        }
        >>
      >>
    }
  }
}
