\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket soprano continuo )
        <<
        \new Staff = SopranoStaff \with { }
        \context Staff = SopranoStaff {
          \set Staff.instrumentName = #"Soprano"
          \relative c {
            \clef "treble"
            \autoBeamOff
            << \new Voice = "soprano_voice1" {
              \time 3/8
              c'8 e g g4.
            } >>
          }
        }
        >>

        <<
        \new Staff = ContinuoStaff \with { }
        \context Staff = ContinuoStaff {
          \set Staff.instrumentName = #"Continuo"
          \relative c {
            \clef "bass"
            << \new Voice = "continuo_voice1" {
              \time 3/8
              r4. b'8 d g
            } >>
          }
        }
        >>
      >>
    }
  }
}
