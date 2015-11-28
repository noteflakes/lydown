\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/8
  } >>
}

"/oboe1/music" = \relative c {
  << \new Voice = "oboe1_voice1" {
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
        <<
          \"/global/music"
          \"/oboe1/music"
        >>
      }
      >>
    }
  }
}
