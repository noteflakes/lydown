\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    a'4 b c d
  } >>
}


\book {
  \header {
  }

  \bookpart { 
    \include "spec/examples/abc.ly"
    \include "spec/def.ly"

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
