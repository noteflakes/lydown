\version "2.18.2"
#(define lydown:render-mode 'part)

"02-outro//music" = \relative c {
  << \new Voice = "voice1" {
    \time 4/4
    \key b \major
    r4. b''8 dis gis
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \header {
        piece = "2. Outro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \set Score.skipBars = ##t
            \"02-outro//music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
