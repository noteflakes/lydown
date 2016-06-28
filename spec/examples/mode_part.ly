\version "2.18.2"
#(define lydown:render-mode 'part)
 
"/viola/music" = \relative c {
  << \new Voice = "viola_voice1" {
   s1 R1*1
  } >>
}

\book {
  \header {
    instrument = "Viola"
  }

  \bookpart { 
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolaStaff \with { }
          \context Staff = ViolaStaff {
            \set Score.skipBars = ##t
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
