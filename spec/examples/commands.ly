\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    \key c \major
    c4 d \key ees \major ees f
    g \stemUp aes
    \once \override AccidentalSuggestion #'avoid-slur = #'outside
    \once \set suggestAccidentals = ##t
    b
    \footnote #'(-0.5 . 2) "lié?" c ees
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
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \"//music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
