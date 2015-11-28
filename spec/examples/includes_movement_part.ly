\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 e8 g c2
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \include "spec/examples/abc.ly"
    % Hello from template
    \include "spec/examples/def.ly"
    \include "spec/examples/ghi.ly"

    \score {
      <<
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \set Score.skipBars = ##t
        \"/global/music"
      }
      >>
    }
  }
}
