\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    %{BWV 52/5%}
    r4 r8 g'' g,4
    r r8 g' g,4
    r r8 g' g,4
    r16 g bis d g8 f e16 c e g
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
