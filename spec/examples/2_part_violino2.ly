\version "2.18.2"
#(define lydown:render-mode 'part)

"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 3/8
    r4. b''8 d g
  } >>
}

\book {
  \header {
    instrument = "Violino II"
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIIStaff \with { }
          \context Staff = ViolinoIIStaff {
            \set Score.skipBars = ##t
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
