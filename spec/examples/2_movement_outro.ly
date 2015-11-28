\version "2.18.2"

"02-outro/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \time 4/4
    \key b \major
    r4. b''8 dis gis
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      \header {
        piece = \markup { \bold \large { 2. Outro } }
      }

      <<
      \new Staff = GlobalStaff \with { }
      \context Staff = GlobalStaff {
        \set Score.skipBars = ##t 
        \"02-outro/global/music"
      }
      >>
    }
  }
}
