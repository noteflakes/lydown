\version "2.18.2"
#(define lydown:render-mode 'score) 
 
"/viola/music" = \relative c {
  << \new Voice = "viola_voice1" {
    c4 e8 g c2 R1*1
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \new OrchestraGroup \with { } << 
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolaStaff \with { }
          \context Staff = ViolaStaff {
            \set Staff.instrumentName = #"Viola"
            \clef "alto"
            \"/viola/music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
