\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        << \new Voice = "voice1" {
          c1^\markup { blah } d_\markup { tralla } dis^\markup { no backslash }
          e^\markup { \italic { italic } }
          fis^\markup { \bold { bold } }
          g\p r^\markup { Jünger ("alto"): }
          r^\markup { \italic { bl ah } }
          r_\markup { bleh }
        } >>
      }
    }
    >>
  }
}
