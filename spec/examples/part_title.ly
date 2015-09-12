\version "2.18.2"

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
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar soprano continuo )
        <<
        \new Staff = SopranoStaff \with { }
        \context Staff = SopranoStaff {
          \set Staff.instrumentName = #"Soprano, Oboe I"
          \clef "treble"
          \set Staff.autoBeaming = ##f
          \"/soprano/music"
        }
        >>

        <<
        \new Staff = ContinuoStaff \with { \override VerticalAxisGroup.remove-empty = ##f }
        \context Staff = ContinuoStaff {
          \set Staff.instrumentName = #"Continuo"
          \clef "bass"
          \"/continuo/music"
        }
        >>
      >>
    }
  }
}
