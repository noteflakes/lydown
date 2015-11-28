\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
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
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \"/global/music"
      }
      >>
    }
  }
}
