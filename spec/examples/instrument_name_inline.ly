\version "2.18.2"

ldFluteIMusic = \relative c {
  << \new Voice = "flute1_voice1" {
  c4 d <>^\markup { \smallCaps { Flute I } } e f
  } >>
}
ldViolinoIIMusic = \relative c {
  << \new Voice = "violino2_voice1" {
  <>^\markup { \smallCaps { Violino II } } 
    g'4 a b c
  } >>
}
ldContinuoMusic = \relative c {
  << \new Voice = "continuo_voice1" {
  <>^\markup { \right-align \smallCaps { Continuo } } 
    e4
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar flute1 violino2 continuo )
        <<
        \new Staff = FluteIStaff \with { }
        \context Staff = FluteIStaff {
          \ldFluteIMusic
        }
        >>

        <<
        \new Staff = ViolinoIIStaff \with {  }
        \context Staff = ViolinoIIStaff {
          \clef "treble"
          \ldViolinoIIMusic
        }
        >>

        <<
        \new Staff = ContinuoStaff \with { 
          \override VerticalAxisGroup.remove-empty = ##f  
        }
        \context Staff = ContinuoStaff {
          \clef "bass"
          \ldContinuoMusic
        }
        >>
      >>
    }
  }
}
