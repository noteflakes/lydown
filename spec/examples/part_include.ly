\version "2.18.2"
#(define lydown:render-mode 'part)

"/violoncello/music" = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/8
    d4. ~ d
  } >>
}

"/soprano/music" = \relative c {
  << \new Voice = "soprano_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

"/soprano/lyrics/voice1/1" = \lyricmode {
  la la la la!
}



\book {
  \header {
    instrument = "Violoncello"
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver"
          \override SpanBar #'break-visibility = #'#( #t #f #t ) } <<
          <<
          \new Staff = SopranoStaff \with { }
          \context Staff = SopranoStaff {
            \set Score.skipBars = ##t
            \clef "treble"
            \set Staff.autoBeaming = ##f
            \"/soprano/music"
          }
          \new Lyrics \with { } {
            \lyricsto "soprano_voice1" { \"/soprano/lyrics/voice1/1" }
          }
          >>
        >>
        \new StaffGroup \with {  } <<
          <<
          \new Staff = VioloncelloStaff \with { }
          \context Staff = VioloncelloStaff {
            \set Score.skipBars = ##t
            \clef "bass"
            \"/violoncello/music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
