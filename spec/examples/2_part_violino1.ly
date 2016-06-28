\version "2.18.2"
#(define lydown:render-mode 'part)

"/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

\book {
  \header {
    instrument = "Violino I"
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIStaff \with { }
          \context Staff = ViolinoIStaff {
            \set Score.skipBars = ##t
            \clef "treble"
            \"/violino1/music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
