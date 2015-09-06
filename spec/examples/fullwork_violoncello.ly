\version "2.18.2"

ldIintroVioloncelloMusic = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/4
    \key d \major
    d8 cis b a gis4
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
      \new Staff = VioloncelloStaff \with { }
      \context Staff = VioloncelloStaff {
        \clef "bass"
        \ldIintroVioloncelloMusic
        \bar "|."
      }
      >>
    }

    \markup { 
      \line { \bold \large { 2. Outro - tacet } }
      \line { \pad-markup #3 " " }
    }
    
  }
}
