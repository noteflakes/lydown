\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c8 c g' g a' a g4
    f8 f e e d d c4 d8[ e f e] d2
  } >>
}
"//lyrics/voice1/1" = \lyricmode {
  Twin -- kle twin -- kle lit -- tle star,
  How I won -- der what you are. __ _ _
}

"//lyrics/voice1/2" = \lyricmode {
  Yeah yeah yeah
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
      \new Lyrics {
        \lyricsto "voice1"  { \"//lyrics/voice1/1" }
      }
      \new Lyrics {
        \lyricsto "voice1"  { \"//lyrics/voice1/2" }
      }
      >>
    }
  }
}
