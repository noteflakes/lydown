\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 d8[ e' f]\f
    \autoBeamOff
    g16 a32[ b] ges8.[ ais16]-. bes8.[ cis16]-.

    c8[( d e f]) g[( a b c])
    \autoBeamOn
  } >>
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
      >>
    }
  }
}
