\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 c-- c-. c-! c
    des'\f dis-.\trill
    e-._\editP
    fisis-.^\editF
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
