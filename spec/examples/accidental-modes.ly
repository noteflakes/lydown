\version "2.18.2"

\book {
  \header {
  }
  
  \bookpart {
    \new Staff = Staff \with { } 
    \context Staff = Staff {
      \relative c {
        \key ees \major %{by default accidentals are relative to key signature%}
        ees4 g bes ees
        %{in manual mode accidentals are always explicit%}
        e ges bes ees
        %{back to default auto(matic) mode%}
        c d ees f
      }
    }
  }
}