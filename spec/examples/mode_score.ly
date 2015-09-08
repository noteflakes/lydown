\version "2.18.2"

ldViolaMusic = \relative c {
  << \new Voice = "viola_voice1" {
    c4 e8 g c2 R1*1
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \new StaffGroup << 
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar viola )
        <<
        \new Staff = ViolaStaff \with { }
        \context Staff = ViolaStaff {
          \set Staff.instrumentName = #"Viola"
          \clef "alto"
          \ldViolaMusic
        }
        >>
      >>
    }
  }
}
