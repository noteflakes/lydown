\version "2.18.2"

"/violoncello/music" = \relative c {
  << \new Voice = "violoncello_voice1" {
    \time 3/8
    d4. ~ d
  } >>
}

"/soprano/music" = \relative c {
  << \new Voice = "soprano_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

"/soprano/lyrics/voice1/1" = \lyricmode {
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
          \"/soprano/music"
        }
        \new Lyrics {
          \lyricsto "soprano_voice1" { \"/soprano/lyrics/voice1/1" }
        }
        >>

        <<
        \new Staff = VioloncelloStaff \with { }
        \context Staff = VioloncelloStaff {
          \set Score.skipBars = ##t 
          \clef "bass"
          \"/violoncello/music"
        }
        >>
      >>
    }
  }
}
