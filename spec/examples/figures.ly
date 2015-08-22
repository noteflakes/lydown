\version "2.18.2"

ldContinuoMusic = \relative c {
  << \new Voice = "continuo_voice1" {
    a'4 r r2
    bes4 r fis r
    f! r e r
    e r r d
    g r f r
    a1
  } >>
}
ldContinuoFigures = \figuremode {
  <6>4 s s2
  s4 s <6> s
  <4 2> s <7 _+> s
  <6> s s s
  s s <4 2> s
  s2 <_+>
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
