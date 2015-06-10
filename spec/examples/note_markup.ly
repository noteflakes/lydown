\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        c1^\markup { blah } d_\markup { tralla }
        e^\markup { \italic { italic } }
        fis^\markup { \bold { bold } }
        g\p r^\markup { Jünger (alto): }
      }
    }
    >>
  }
}
