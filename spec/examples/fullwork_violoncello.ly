\version "2.18.2"

"01-intro/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \key d \major \time 3/4
  } >>
}
"01-intro/violoncello/music" = \relative c {
  << \new Voice = "violoncello_voice1" {
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
        <<
          \"01-intro/global/music"
          \"01-intro/violoncello/music"
        >>
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
