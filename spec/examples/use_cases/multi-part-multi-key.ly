\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = ViolinoIStaff \with { }
    \context Staff = ViolinoIStaff {
      \relative c {
        \clef "treble"
        << \new Voice = "violino1_voice1" {
          \key fis \minor fis1
          \key d \minor f
        } >>
      }
    }
    >>

    <<
    \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }
    \context Staff = ContinuoStaff {
      \relative c {
        \clef "bass"
        << \new Voice = "continuo_voice1" {
          \key fis \minor cis1
          \key d \minor c
        } >>
      }
    }
    >>
  }
}
