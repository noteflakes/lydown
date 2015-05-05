\version "2.18.2"
\book {
  \header {
  }
  
  \new Staff = Staff \with { } 
  \context Staff = Staff {
    \relative c {
      c4 ~ c16 b a g
      %{in macros%}
      \key aes \major
      c4 ~ c16 bes aes g
  
      %{short tie%}
      f4 ~ f16 ees des c
      bes4 ~ bes16 aes g f
  
      %{short tie in macro%}
      aes4 ~ aes16 g f ees
    }
  }
}