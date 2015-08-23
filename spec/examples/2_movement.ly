\version "2.18.2"

ldIintroMusic = \relative c {
  << \new Voice = "voice1" {
    \time 3/8
    \key c \minor
    c'8 ees g g4.
  } >>
}
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
      piece = \markup { \bold \large { 1. Intro } }
    }

      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \set Score.skipBars = ##t 
        \ldIintroMusic
      }
      >>
  }
  \score {
    \header {
      piece = \markup { \bold \large { 2. Outro } }
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
