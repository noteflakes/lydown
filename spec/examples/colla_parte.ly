\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 3/8
  } >>
}

"/viola/music" = \relative c {
  << \new Voice = "viola_voice1" {
    r4. b''8 d g
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = ViolaStaff \with { }
      \context Staff = ViolaStaff {
        \set Score.skipBars = ##t 
        \clef "alto"
        <<
          \"/global/music"
          \"/viola/music"
        >>
      }
      >>
    }
  }
}
