\version "2.18.2"

ldSopranoMusic = \relative c {
  << \new Voice = "soprano_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}
ldContinuoMusic = \relative c {
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
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar soprano continuo )
        <<
        \new Staff = SopranoStaff \with { }
        \context Staff = SopranoStaff {
          \set Staff.instrumentName = #"Soprano"
          \clef "treble"
          \set Staff.autoBeaming = ##f
          \ldSopranoMusic
        }
        >>

        <<
        \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }
        \context Staff = ContinuoStaff {
          \set Staff.instrumentName = #"Continuo"
          \clef "bass"
          \ldContinuoMusic
        }
        >>
      >>
    }
  }
}
