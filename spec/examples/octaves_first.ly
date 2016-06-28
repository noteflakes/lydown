\version "2.18.2"

"/soprano/music" = \relative c {
  <<
    \new Voice = "soprano_voice1" {
      e''4 f g,
    }
  >>
}
"/alto/music" = \relative c {
  <<
    \new Voice = "alto_voice1" {
       g''4 a b
    }
  >>
}
"/tenore/music" = \relative c {
  <<
    \new Voice = "tenore_voice1" {
       d'4 e f'
    }
  >>
}
"/basso/music" = \relative c {
  <<
    \new Voice = "basso_voice1" {
      a4 b c,,
    }
  >>
}

\book {
  \header { }
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
          >>
          <<
            \new Staff = AltoStaff \with { }
            \context Staff = AltoStaff {
              \clef "treble"
              \set Staff.autoBeaming = ##f
              \"/alto/music"
            }
          >>
          <<
            \new Staff = TenoreStaff \with { }
            \context Staff = TenoreStaff {
              \clef "treble_8"
              \set Staff.autoBeaming = ##f
              \"/tenore/music"
            }
          >>
          <<
            \new Staff = BassoStaff \with { }
            \context Staff = BassoStaff {
              \clef "bass"
              \set Staff.autoBeaming = ##f
              \"/basso/music"
            }
          >>
        >>
      >>
      \layout { }
    }
  }
}
