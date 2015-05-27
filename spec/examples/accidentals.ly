\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        \key d \major
        cis4 d e fis
        \key a \minor
        gis ais bes
        \key cis \minor
        cis dis e fis gis aes
        \key ees \major
        bes c d ees f fis g gis a
        %{accidental flags%}
        cis'! ees? g!8.
        %{alternative accidental/octave order%}
        ges,4 a'''2 b'4
      }
    }
    >>
  }
}
