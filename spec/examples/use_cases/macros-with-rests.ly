\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    %{BWV 52/5%}
    r4 r8 g'' g,4
    r r8 g' g,4
    r r8 g' g,4
    r16 g bis d g8 f e16 c e g
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
