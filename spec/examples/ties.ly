\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c4 ~ c16 b a g
    %{in macros%}
    \key aes \major
    c4 ~ c16 bes aes g

    %{short tie%}
    f4 ~ f16 ees des c
    bes4 ~ bes16 aes g f

    %{short tie in macro%}
    aes4 ~ aes16 g f ees
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
