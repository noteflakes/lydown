\version "2.18.2"

"/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    \key fis \minor fis1
    \key d \minor f
  } >>
}
"/continuo/music" = \relative c {
  << \new Voice = "continuo_voice1" {
    \key fis \minor cis1
    \key d \minor c
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIStaff \with { }
          \context Staff = ViolinoIStaff {
            \clef "treble"
            \"/violino1/music"
          }
          >>
        >>
        \new StaffGroup \with { } <<
          <<
          \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }
          \context Staff = ContinuoStaff {
            \clef "bass"
            \"/continuo/music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
