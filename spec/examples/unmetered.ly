\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
  \cadenzaOn
  c4 c d e \bar "|" d d d d f f d \bar "|" e c d
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
