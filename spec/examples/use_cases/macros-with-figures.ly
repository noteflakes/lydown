\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    %{BWV 244%}
    e4 e8 f4 f8
  } >>
}

"//figures" = \figuremode {
  <7>4 <6>8 <5>4 \bassFigureExtendersOn <5>8 \bassFigureExtendersOff 
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \"//music"
          }

          \new FiguredBass { \"//figures" }
          >>
        >>
      >>
      \layout { }
    }
  }
}
