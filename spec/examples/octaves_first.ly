\version "2.18.2" 
\book {
  \header { } 
  \bookpart { 
    << 
      \new Staff = SopranoStaff \with { } 
      \context Staff = SopranoStaff { 
        \relative c { 
          \clef "treble" 
          << 
            \new Voice = "soprano_voice1" { 
              \autoBeamOff e''4 f g, 
            } 
          >> 
        } 
      } 
    >> 
    << 
      \new Staff = AltoStaff \with { } 
      \context Staff = AltoStaff { 
        \relative c { 
          \clef "treble"
          << 
            \new Voice = "alto_voice1" { 
              \autoBeamOff g''4 a b 
            } 
          >> 
        } 
      } 
    >> 
    << 
      \new Staff = TenoreStaff \with { } 
      \context Staff = TenoreStaff { 
        \relative c { 
          \clef "treble_8"
          << 
            \new Voice = "tenore_voice1" { 
              \autoBeamOff d'4 e f' 
            } 
          >> 
        } 
      } 
    >> 
    << 
      \new Staff = BassoStaff \with { } 
      \context Staff = BassoStaff { 
        \relative c { 
          \clef "bass"
          <<
            \new Voice = "basso_voice1" { 
              \autoBeamOff a4 b c,, 
            }
          >>
        }
      }
    >>
  }
}