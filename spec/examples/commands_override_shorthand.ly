\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \once \override Stem.details.beamed-lengths = #'(4 4 3)
    \override Stem.thickness = #5.0
    \override TextSpanner.bound-details.left.text = #"left text"
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
