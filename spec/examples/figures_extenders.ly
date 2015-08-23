\version "2.18.2"

ldContinuoMusic = \relative c {
  << \new Voice = "continuo_voice1" {
    c8 d e c
  } >>
}
ldContinuoFigures = \figuremode {
  <7 4>8 \bassFigureExtendersOn <7 4> <7 4> <7 3> \bassFigureExtendersOff
}

\book {
  \header {
  }

  \score {
    <<
    \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }

    \context Staff = ContinuoStaff {
      \clef "bass"
      \ldContinuoMusic
    }

    \new FiguredBass { \ldContinuoFigures }

    >>
  }
}
