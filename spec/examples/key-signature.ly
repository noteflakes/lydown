\version "2.18.2"

ldMusic = \relative c {
  << \new Voice = "voice1" {
    \key c \major
    c4 d e f
    \key a \minor
    g a b c
    %{only the f+ minor key signature will be rendered%}
    \key fis \minor
    a b cis
    %{shorthand notation%}
    \key f \major
    a bes c
    \key ees \minor
    aes bes ces
  } >>
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \ldMusic
      }
      >>
    }
  }
}
