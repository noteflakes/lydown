\version "2.18.2"
#(define lydown:render-mode 'part)

"01-intro//music" = \relative c {
  << \new Voice = "voice1" {
    \time 3/8
    \key c \minor
    c'8 ees g g4.
  } >>
}
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
        piece = "1. Intro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \set Score.skipBars = ##t
            \"01-intro//music"
          }
          >>
        >>
      >>
      \layout { }
    }
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
