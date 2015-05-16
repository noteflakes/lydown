\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        c4 d8[ e' f\f]
        \autoBeamOff
        g16 a32[ b] ges8.[ ais16]-. bes8.[ cis16]-.
        \autoBeamOn
      }
    }
    >>
  }
}
