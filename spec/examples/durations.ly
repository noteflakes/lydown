\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c4 d8 e16 f32 g a4 b

    c8. d16 e8. f16 g2

    r16.. c32 r16 f r c r f
    
    c\breve e1 g c\longa

    r c\longa. c\breve.
    
    c4 d \once \override Tie #'transparent = ##t e2 ~
         \once \override NoteHead #'transparent = ##t 
         \once \override Dots #'extra-offset = #'(-1.3 . 0) 
         \once \override Stem #'transparent = ##t 
         e2.*0 s4
      f4 e d
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \"//music"
      }
      >>
    }
  }
}
