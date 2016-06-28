\version "2.18.2"
#(define lydown:render-mode 'score)

"02-outro/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 2/4
    \key bes \major
    ees4 f8 g a2
  } >>
}
"02-outro/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    \time 2/4
    \key bes \major
    g'4 f8 ees d2
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \header {
        piece = "2. Outro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIStaff \with { }
          \context Staff = ViolinoIStaff {
            \set Staff.instrumentName = #"Violino I"
            \clef "treble"
            \"02-outro/violino1/music"
            \bar "|."
          }
          >>

          <<
          \new Staff = ViolinoIIStaff \with { }
          \context Staff = ViolinoIIStaff {
            \set Staff.instrumentName = #"Violino II"
            \clef "treble"
            \"02-outro/violino2/music"
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
