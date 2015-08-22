\version "2.18.2"

ldSopranoIMusic = \relative c {
  << \new Voice = "soprano1_voice1" {
    c8 c g' g a' a g4
  } >>
}
ldSopranoILyricsVoiceOneI = \lyricmode {
  Twin -- kle twin -- kle lit -- tle star,
}
ldSopranoIIMusic = \relative c {
  << \new Voice = "soprano2_voice1" {
    f8 f e e d d c4 d8[ e f e] d2
  } >>
}
ldSopranoIILyricsVoiceOneI = \lyricmode {
  How I won -- der what you are. __ _ _
}

\book {
  \header {
  }

  \score {
    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBracket soprano1 soprano2)
      <<
      \new Staff = SopranoIStaff \with { }
      \context Staff = SopranoIStaff {
        \set Staff.instrumentName = #"Soprano I"
        \clef "treble"
        \set Staff.autoBeaming = ##f
        \ldSopranoIMusic
      }
      \new Lyrics {
        \lyricsto "soprano1_voice1" { \ldSopranoILyricsVoiceOneI }
      }
      >>

      <<
      \new Staff = SopranoIIStaff \with { }
      \context Staff = SopranoIIStaff {
        \set Staff.instrumentName = #"Soprano II"
        \clef "treble"
        \set Staff.autoBeaming = ##f
        \ldSopranoIIMusic
      }
      \new Lyrics {
        \lyricsto "soprano2_voice1" { \ldSopranoIILyricsVoiceOneI }
      }
      >>
    >>
  }
}
