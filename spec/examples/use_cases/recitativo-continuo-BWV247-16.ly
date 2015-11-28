\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c1
    b2 bes
  } >>
}
"/global/figures" = \figuremode { <_->2 <4+> <6> <6> }

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
      \new FiguredBass { \"/global/figures" }
      >>
    }
  }
}
