\version "2.18.2"

ldVioloncelloMusic = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/8
    d4. ~ d
  } >>
}

ldSopranoMusic = \relative c {
  << \new Voice = "soprano_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

ldSopranoLyricsVoiceOneI = \lyricmode {
  la la la la!
}



\book {
  \header {
  }

  \bookpart { 
    \score {
      \new StaffGroup <<
        \set StaffGroup.systemStartDelimiterHierarchy = #'(SystemStartBar soprano violoncello )
        <<
        \new Staff = SopranoStaff \with { }
        \context Staff = SopranoStaff {
          \set Score.skipBars = ##t 
          \clef "treble"
          \set Staff.autoBeaming = ##f
          \ldSopranoMusic
        }
        \new Lyrics {
          \lyricsto "soprano_voice1" { \ldSopranoLyricsVoiceOneI }
        }
        >>

        <<
        \new Staff = VioloncelloStaff \with { }
        \context Staff = VioloncelloStaff {
          \set Score.skipBars = ##t 
          \clef "bass"
          \ldVioloncelloMusic
        }
        >>
      >>
    }
  }
}
