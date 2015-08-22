\version "2.18.2"

ldIIoutroMusic = \relative c {
  << \new Voice = "voice1" {
    \time 4/4
    \key b \major
    r4. b''8 dis gis
  } >>
}

\book {
  \header {
  }

  \score {
    \header {
      piece = \markup {
        \column {
          \fill-line {\bold \large "2. Outro"}

        }
      }
    }

    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \set Score.skipBars = ##t 
      \ldIIoutroMusic
    }
    >>
  }
}
