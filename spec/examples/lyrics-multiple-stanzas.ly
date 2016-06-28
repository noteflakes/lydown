\version "2.18.2"

"/soprano/music" = \relative c {
  << \new Voice = "soprano_voice1" {
    c8 c g' g a' a g4
    f8 f e e d d c4 d8[ e f e] d2
  } >>
}
"/soprano/lyrics/voice1/1" = \lyricmode {
  Twin -- kle twin -- kle lit -- tle star,
  How I won -- der what you are. __ _ _
}
"/soprano/lyrics/voice1/2" = \lyricmode {
  When the blah blah shines up high,
  Then the blah blah blah blah sky. __ _ _
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
            \clef "treble"
            \set Staff.autoBeaming = ##f
            \"/soprano/music"
          }
          \new Lyrics \with { } {
            \lyricsto "soprano_voice1" { \"/soprano/lyrics/voice1/1" }
          }
          \new Lyrics \with { } {
            \lyricsto "soprano_voice1" { \"/soprano/lyrics/voice1/2" }
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
