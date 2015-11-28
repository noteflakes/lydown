\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    \key c \major
    c4 d \key ees \major ees f
    g \stemUp aes 
    \once \override AccidentalSuggestion #'avoid-slur = #'outside 
    \once \set suggestAccidentals = ##t
    b
    \footnote #'(-0.5 . 2) "lié?" c ees
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
