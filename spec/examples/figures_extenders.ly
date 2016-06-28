\version "2.18.2"

"/continuo/music" = \relative c {
  << \new Voice = "continuo_voice1" {
    c8 d e c
  } >>
}
"/continuo/figures" = \figuremode {
  <7 4>8 \bassFigureExtendersOn <7 4> <7 4> <7 3> \bassFigureExtendersOff
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
