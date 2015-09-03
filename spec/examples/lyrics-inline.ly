\version "2.18.2"

ldSopranoMusic = \relative c {
  << \new Voice = "soprano_voice1" {
    c8 c g' g a' a g4
    f8 f e e d d c4 d8[ e f e] d2
  } >>
}
ldSopranoLyricsVoiceOneI = \lyricmode {
  Twin -- kle twin -- kle lit -- tle star,
  How I won -- der what you are. __ _ _
}
ldSopranoLyricsVoiceOneII = \lyricmode {
  When the blah blah shines up high,
  Then the blah blah blah blah sky. __ _ _
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = SopranoStaff \with { }
      \context Staff = SopranoStaff {
        \clef "treble"
        \set Staff.autoBeaming = ##f
        \ldSopranoMusic
      }
      \new Lyrics {
        \lyricsto "soprano_voice1" { \ldSopranoLyricsVoiceOneI }
      }
      \new Lyrics {
        \lyricsto "soprano_voice1" { \ldSopranoLyricsVoiceOneII }
      }
      >>
    }
  }
}
