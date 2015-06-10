\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = ViolinoIIStaff \with { }
    \context Staff = ViolinoIIStaff {
      \relative c {
        \clef "treble"
        << \new Voice = "voice1" {
          \time 3/8
          r4. b'8 d g
        } >>
      }
    }
    >>
  }
}
