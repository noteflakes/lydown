\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        << \new Voice = "voice1" {
          a8. g16[ f8] ees'
          c c c c d d d d R1*1
          d16(\p c) d( b)
          
          %{command in the middle of a macro group%}
          e8 \clef "bass" e,, e e' e d16 c

          %{partial macro group%}
          b8 c16 d4( e)
        } >>
      }
    }
    >>
  }
}
