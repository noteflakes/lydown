\version "2.18.2"
#(define lydown:render-mode 'score) 

"/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}
"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 3/8
    r4. b''8 d g
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
          \new Staff = ViolinoIStaff \with { }
          \context Staff = ViolinoIStaff {
            \set Staff.instrumentName = #"Violino I"
            \clef "treble"
            \"/violino1/music"
          }
          >>

          <<
          \new Staff = ViolinoIIStaff \with { }
          \context Staff = ViolinoIIStaff {
            \set Staff.instrumentName = #"Violino II"
            \clef "treble"
            \"/violino2/music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
