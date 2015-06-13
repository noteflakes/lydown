\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = ContinuoStaff \with { }

    \context Staff = ContinuoStaff {
      \relative c {
        \clef "bass"
        << \new Voice = "continuo_voice1" {
          a4 r r2
          bes4 r fis r
          f! r e r
          e r r d
          g r f r
          a1
        } >>
      }
    }

    \figures {
      <6>4 s s2
      s4 s <6> s
      <4 2> s <7 _+> s
      <6> s s s
      s s <4 2> s
      s2 <_+>
    }

    >>
  }
}
