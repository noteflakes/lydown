\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    a'8. g16[ f8] ees'
    c c c c d d d d R1*1
    d16(\p c) d( b)
    
    %{command in the middle of a macro group%}
    e8 \clef "bass" e,, e e' e d16 c

    %{command between macro groups%}
    e8 e''16 \clef "treble" e8 e'16 e8 d16

    %{partial macro group%}
    b8 c16 d4( e)
  } >>
}

\book {
  \header {
  }

  \score {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \ldMusic
    }
    >>
  }
}
