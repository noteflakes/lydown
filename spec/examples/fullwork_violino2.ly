\version "2.18.2"

"02-outro/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4
    \key bes \major
    g'4 f8 ees d2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \markup { 
      \line { \bold \large { 1. Intro - tacet } }
      \line { \pad-markup #3 " " }
    }
    
    \score {
      \header {
        piece = \markup { \bold \large { 2. Outro } }
      }

      <<
      \new Staff = ViolinoIIStaff \with { }
      \context Staff = ViolinoIIStaff {
        \clef "treble"
        \"02-outro/violino2/music"
        \bar "|."
      }
      >>
    }
  }
}
