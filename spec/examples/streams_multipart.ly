\version "2.18.2"
\book {
  \header {
  }

  \bookpart {
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket soprano1 soprano2 )
        <<
        \new Staff = SopranoIStaff \with { }
        \context Staff = SopranoIStaff {
          \set Staff.instrumentName = #"Soprano I"
          \relative c {
            \clef "treble"
            \autoBeamOff
            c8 c g' g a' a g4
          }
        }
        \addlyrics {
          Twin -- kle twin -- kle lit -- tle star,
        }
        >>

        <<
        \new Staff = SopranoIIStaff \with { }
        \context Staff = SopranoIIStaff {
          \set Staff.instrumentName = #"Soprano II"
          \relative c {
            \clef "treble"
            \autoBeamOff
            f8 f e e d d c4 d8[ e f e] d2
          }
        }
        \addlyrics {
          How I won -- der what you are. __ _ _
        }
        >>
      >>
    }
  }
}