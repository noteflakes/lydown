\version "2.18.2"

"/oboe1/music" = \relative c {
  << \new Voice = "oboe1_voice1" {
    \time 3/8
    c'8 e g g4.
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = OboeIStaff \with { }
      \context Staff = OboeIStaff {
        \set Score.skipBars = ##t
        \clef "treble"
        \"/oboe1/music"
      }
      >>
    }
  }
}
