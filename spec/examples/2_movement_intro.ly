\version "2.18.2"

"01-intro/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/8
    \key c \minor
    c'8 ees g g4.
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \header {
        piece = \markup { \bold \large { 1. Intro } }
      }

      <<
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \"01-intro/global/music"
      }
      >>
    }
  }
}
