\version "2.18.2" 

ldSopranoMusic = \relative c { 
  << 
    \new Voice = "soprano_voice1" { 
      e''4 f g, 
    }
  >>
}
ldAltoMusic = \relative c { 
  << 
    \new Voice = "alto_voice1" { 
       g''4 a b 
    } 
  >> 
}
ldTenoreMusic = \relative c { 
  << 
    \new Voice = "tenore_voice1" { 
       d'4 e f' 
    } 
  >> 
}
ldBassoMusic = \relative c { 
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
      << 
        \new Staff = SopranoStaff \with { } 
        \context Staff = SopranoStaff { 
          \clef "treble"
          \set Staff.autoBeaming = ##f
          \ldSopranoMusic 
        } 
      >> 
      << 
        \new Staff = AltoStaff \with { } 
        \context Staff = AltoStaff { 
          \clef "treble"
          \set Staff.autoBeaming = ##f
          \ldAltoMusic 
        } 
      >> 
      << 
        \new Staff = TenoreStaff \with { } 
        \context Staff = TenoreStaff { 
          \clef "treble_8"
          \set Staff.autoBeaming = ##f
          \ldTenoreMusic 
        } 
      >> 
      << 
        \new Staff = BassoStaff \with { } 
        \context Staff = BassoStaff { 
          \clef "bass"
          \set Staff.autoBeaming = ##f
          \ldBassoMusic
        }
      >>
    }
  }
}