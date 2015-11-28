\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/8
  } >>
}
"/violino2/music" = \relative c {
  << \new Voice = "violino2_voice1" {
    r4. b''8 d g
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = ViolinoIIStaff \with { }
      \context Staff = ViolinoIIStaff {
        \set Score.skipBars = ##t 
        \clef "treble"
        <<
          \"/global/music"
          \"/violino2/music"
        >>
      }
      >>
    }
  }
}
