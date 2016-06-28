\version "2.18.2"
#(define lydown:render-mode 'score)

"01-intro/violino1/music" = \relative c {
  << \new Voice = "violino1_voice1" {
    \time 3/4
    \key d \major
    a'8 b cis d e4
  } >>
}
"01-intro/violoncello/music" = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/4
    \key d \major
    d8 cis b a gis4
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \header {
        piece = "1. Intro"
      }

      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = ViolinoIStaff \with { }
          \context Staff = ViolinoIStaff {
            \set Staff.instrumentName = #"Violino I"
            \clef "treble"
            \"01-intro/violino1/music"
            \bar "|."
          }
          >>
        >>
        \new StaffGroup \with { } <<
          <<
          \new Staff = VioloncelloStaff \with { }
          \context Staff = VioloncelloStaff {
            \set Staff.instrumentName = #"Violoncello"
            \clef "bass"
            \"01-intro/violoncello/music"
            \bar "|."
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
