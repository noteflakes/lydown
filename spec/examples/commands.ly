\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        \key c \major
        c4 d \key ees \major ees f
        g \stemUp aes 
        \once \override AccidentalSuggestion #'avoid-slur = #'outside 
        \once \set suggestAccidentals = ##t
        b
        
      }
    }
    >>
  }
}
