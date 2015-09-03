\version "2.18.2"

ldGambaIMusic = \relative c {
  << \new Voice = "gamba1_voice1" {
    c4 d e f g1
  } >>
}

\book {
  \header {
  }
  \bookpart { 
    \score {
      \new StaffGroup << \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar gamba1 )
        <<
        \new Staff = GambaIStaff \with { }
        \context Staff = GambaIStaff {
          \set Staff.instrumentName = #"Gamba I" 
          \clef "alto"
          \ldGambaIMusic
          \bar "|."
        }
        >>
      >>
    }
    \pageBreak
  }
}
