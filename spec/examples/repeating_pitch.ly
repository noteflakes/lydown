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
          cis'4 ~ cis ges2
          ges16-- ges ges ges
          c4 d8 ees,4 ees8
        } >>
      }
    }
    >>
  }
}
