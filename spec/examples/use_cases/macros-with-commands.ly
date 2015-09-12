\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    r16 d' ees16. ces32 g8 r r16 fes g16. e32 c8 r \clef "bass"
    r16 a d16. e32 f8 r r2 \clef "alto"
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \"//music"
      }
      >>
    }
  }
}
