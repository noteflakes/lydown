\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \key d \major
    g'16 a b g e4 <fis d>2
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
