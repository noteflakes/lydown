\version "2.18.2"
#(define lydown:render-mode 'score)

"/flute1/music" = \relative c {
  << \new Voice = "flute1_voice1" {
  c4 d <>^\markup { \smallCaps { Flute I } } e f
  } >>
}
"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
  <>^\markup { \smallCaps { Violino II } }
    g'4 a b c
  } >>
}
"/continuo/music" = \relative c {
  << \new Voice = "continuo_voice1" {
  <>^\markup { \right-align \smallCaps { Continuo } }
    e4
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
          \new Staff = FluteIStaff \with { }
          \context Staff = FluteIStaff {
            \"/flute1/music"
          }
          >>
        >>
        \new StaffGroup \with { } <<
          <<
          \new Staff = ViolinoIIStaff \with {  }
          \context Staff = ViolinoIIStaff {
            \clef "treble"
            \"/violino2/music"
          }
          >>
        >>
        \new StaffGroup \with { } <<
          <<
          \new Staff = ContinuoStaff \with {
            \override VerticalAxisGroup.remove-empty = ##f
          }
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
