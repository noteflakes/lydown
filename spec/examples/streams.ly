\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c8 c g' g a' a g4
    f8 f e e d d c4 d8[ e f e] d2
  } >>
}
"/global/lyrics/voice1/1" = \lyricmode {
  Twin -- kle twin -- kle lit -- tle star,
  How I won -- der what you are. __ _ _
}

"/global/lyrics/voice1/2" = \lyricmode {
  Yeah yeah yeah
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \"/global/music"
      }
      \new Lyrics {
        \lyricsto "global_voice1"  { \"/global/lyrics/voice1/1" }
      }
      \new Lyrics {
        \lyricsto "global_voice1"  { \"/global/lyrics/voice1/2" }
      }
      >>
    }
  }
}
