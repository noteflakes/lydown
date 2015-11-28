\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 d e f
    %{this is a comment on a separate line%}
    g a b c
    %{this is a comment at the end of a line%}
    \time 4/4
    %{this is a comment on a setting line%}
    d
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
