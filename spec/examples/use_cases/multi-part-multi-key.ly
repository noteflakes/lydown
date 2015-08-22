\version "2.18.2"

ldViolinoIMusic = \relative c {
  << \new Voice = "violino1_voice1" {
    \key fis \minor fis1
    \key d \minor f
  } >>
}
ldContinuoMusic = \relative c {
  << \new Voice = "continuo_voice1" {
    \key fis \minor cis1
    \key d \minor c
  } >>
}

\book {
  \header {
  }

  \score {
    <<
    \new Staff = ViolinoIStaff \with { }
    \context Staff = ViolinoIStaff {
      \clef "treble"
      \ldViolinoIMusic
    }
    >>

    <<
    \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }
    \context Staff = ContinuoStaff {
      \clef "bass"
      \ldContinuoMusic
    }
    >>
  }
}
