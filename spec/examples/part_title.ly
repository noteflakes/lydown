\version "2.18.2"
#(define lydown:render-mode 'score)

"/soprano/music" = \relative c {
  << \new Voice = "soprano_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}
"/continuo/music" = \relative c {
  << \new Voice = "continuo_voice1" {
    \time 3/8
    r4. b''8 d g
  } >>
}


\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver"
          \override SpanBar #'break-visibility = #'#( #t #f #t ) } <<
          <<
          \new Staff = SopranoStaff \with { }
          \context Staff = SopranoStaff {
            \set Staff.instrumentName = #"Soprano, Oboe I"
            \clef "treble"
            \set Staff.autoBeaming = ##f
            \"/soprano/music"
          }
          >>
        >>
        \new StaffGroup \with { } <<
          <<
          \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }
          \context Staff = ContinuoStaff {
            \set Staff.instrumentName = #"Continuo"
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
