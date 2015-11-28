\version "2.18.2"

"/global/music" = \relative c {
  << \new Voice = "global_voice1" {
    c1 \bar "|" d \bar "." e \bar "||" f \bar ".|"
    g \bar ".." a \bar "|.|" b \bar "|."

    c \bar ".|:" d \bar ":..:" e \bar ":|.|:" f \bar ":|.:"
    g \bar ":.|.:" a \bar "[|:" b \bar ":|][|:"
    c \bar ":|]" d \bar ":|." e \bar ":|:" f \bar ":|" g \bar "" a
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
