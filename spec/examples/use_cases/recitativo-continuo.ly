\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    e4 r r2 R1*1 g4 r r2 fis4 r r2 fis4 r r2 e4 a r g R1*1 fis4 r b r
  } >>
}
"/global/figures" = \figuremode { <_+>4 s s2 s1*1 <4+ 2>4 s s2 <7 _+>4 s s2 <6 4>4 s s2 <_+>4 s s <4+ 2+> s1*1 <_+>4 }

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
