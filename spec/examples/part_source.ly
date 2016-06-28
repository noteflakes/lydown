\version "2.18.2"
#(define lydown:render-mode 'part)

"/oboe1/music" = \relative c {
  << \new Voice = "oboe1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

\book {
  \header {
    instrument = "Oboe I"
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = OboeIStaff \with { }
          \context Staff = OboeIStaff {
            \set Score.skipBars = ##t
            \clef "treble"
            \"/oboe1/music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
