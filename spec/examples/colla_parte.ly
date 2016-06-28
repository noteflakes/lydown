\version "2.18.2"
#(define lydown:render-mode 'part)

"/viola/music" = \relative c {
  << \new Voice = "viola_voice1" {
    \time 3/8
    r4. b''8 d g
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
