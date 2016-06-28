\version "2.18.2"
#(define lydown:render-mode 'score)

\require "abc"
\require "def"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \require "ghi"

    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \set Staff.instrumentName = #""
            \"//music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
