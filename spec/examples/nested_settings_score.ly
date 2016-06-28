\version "2.18.2"
#(define lydown:render-mode 'score)

"/gamba1/music" = \relative c {
  << \new Voice = "gamba1_voice1" {
    c4 d e f g1
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
          \new Staff = GambaIStaff \with { }
          \context Staff = GambaIStaff {
            \set Staff.instrumentName = #"Gamba I"
            \clef "alto"
            \"/gamba1/music"
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }
    \pageBreak
  }
}
