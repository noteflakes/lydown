\version "2.18.2"

"/continuo/music" = \relative c {
  << \new Voice = "continuo_voice1" {
    a'4 r r2
    bes4 r fis r
    f! r e r
    e r r d
    g r f r
    a1
    c,8 d e c c d e c
    c d e c
  } >>
}
"/continuo/figures" = \figuremode {
  <6>4 s s2
  s4 s <6> s
  <4 2> s <7 _+> s
  <6> s s s
  s s <4 2> s
  s2 <_+>
  <7 4>8 \bassFigureExtendersOn <7 4> <7 3> <7 3> \bassFigureExtendersOff
  \bassFigureExtendersOn <_> <_> <_> <_> \bassFigureExtendersOff
  <7 4> \bassFigureExtendersOn <7 4> <7 4> <7 3> \bassFigureExtendersOff
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }

          \context Staff = ContinuoStaff {
            \clef "bass"
            \"/continuo/music"
          }

          \new FiguredBass { \"/continuo/figures" }
          >>
        >>
      >>
      \layout { }
    }
  }
}
