\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    c1^\markup { blah } d_\markup { tralla } dis^\markup { no backslash }
    e^\markup { \italic { italic } }
    fis^\markup { \bold { bold } }
    g\p r^\markup { Jünger ("alto"): }
    r^\markup { \italic { bl ah } }
    r_\markup { bleh }
    g^\markup { \right-align { \italic { right-aligned } } } 
    b_\markup { \left-align { \italic { left-aligned } } } 
    d^\markup { \center-align { \italic { centered } } }
    R1*1^\markup { fullbar }
    R1*2^\markup { double fullbar }
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \ldMusic
      }
      >>
    }
  }
}
