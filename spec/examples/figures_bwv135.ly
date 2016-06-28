\version "2.18.2"

"/continuo/music" = \relative c {
  << \new Voice = "continuo_voice1" {
    \time 3/4
    \key a \minor
    e2.
    a2 g4
    f2 e4
    d2.
    e ~
    e ~
    e ~
    e2 r4
    R2.*4
    b'2.
    c2 c4
    b2 b4
    a2. ~
    a ~
    a ~
    a2 r4
  } >>
}
"/continuo/figures" = \figuremode {
  <_+>2.
  s2 <6 4 2>4
  <6 5> <6 4 2> <5>8 <6\\>
  <5 4>4 \bassFigureExtendersOn <5 3> \bassFigureExtendersOff <6>8 <5>
  <7 _+>4 <6 4 2/> <7 5 _+>
  <6 5 _+> \bassFigureExtendersOn <6 4> \bassFigureExtendersOff <5 _+>
  <6 4> <7\\ 4 2/>2
  <8 5 _+> s4
  s2.*4
  <6/>2.
  <6>2 s4
  <7> <6>2
  <7 _+>4 <6 4> <5 _+>
  <6 5 _+>8 \bassFigureExtendersOn <6 4> \bassFigureExtendersOff <5 _+>4 <6 4>
  <6 4 2> <7\\ 4 2>2
  <8 5 3>
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
