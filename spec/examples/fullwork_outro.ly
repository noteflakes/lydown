\version "2.18.2"

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
