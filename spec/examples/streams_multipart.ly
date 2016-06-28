\version "2.18.2"
 #(define lydown:render-mode 'score)

"/soprano1/music" = \relative c {
  << \new Voice = "soprano1_voice1" {
    c8 c g' g a' a g4
  } >>
}
"/soprano1/lyrics/voice1/1" = \lyricmode {
  Twin -- kle twin -- kle lit -- tle star,
}
"/soprano2/music" = \relative c {
  << \new Voice = "soprano2_voice1" {
    f8 f e e d d c4 d8[ e f e] d2
  } >>
}
"/soprano2/lyrics/voice1/1" = \lyricmode {
  How I won -- der what you are. __ _ _
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { }  <<
        \new StaffGroup \with {
          \consists "Bar_number_engraver"
          \override SpanBar #'break-visibility = #'#( #t #f #t ) } <<
            <<
            \new Staff = SopranoIStaff \with { }
            \context Staff = SopranoIStaff {
              \set Staff.instrumentName = #"Soprano I"
              \clef "treble"
              \set Staff.autoBeaming = ##f
              \"/soprano1/music"
            }
            \new Lyrics \with { } {
              \lyricsto "soprano1_voice1" { \"/soprano1/lyrics/voice1/1" }
            }
            >>

          <<
          \new Staff = SopranoIIStaff \with { }
          \context Staff = SopranoIIStaff {
            \set Staff.instrumentName = #"Soprano II"
            \clef "treble"
            \set Staff.autoBeaming = ##f
            \"/soprano2/music"
          }
          \new Lyrics \with { } {
            \lyricsto "soprano2_voice1" { \"/soprano2/lyrics/voice1/1" }
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
