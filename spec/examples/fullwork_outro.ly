\version "2.18.2"

ldIIoutroViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 2/4
    \key bes \major
    ees4 f8 g a2
  } >>
}
ldIIoutroViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4
    \key bes \major
    g'4 f8 ees d2
  } >>
}

\book {
  \header {
  }

  \score {
    \header {
      piece = \markup { \bold \large { 2. Outro } }
    }

    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket (SystemStartBrace violino1 violino2) )
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
