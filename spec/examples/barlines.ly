\version "2.18.2"

\book {
  \header {
  }

  \bookpart {
    <<
    \new Staff = Staff \with { }
    \context Staff = Staff {
      \relative c {
        c1 \bar "|" d \bar "." e \bar "||" f \bar ".|"
        g \bar ".." a \bar "|.|" b \bar "|."

        c \bar ".|:" d \bar ":..:" e \bar ":|.|:" f \bar ":|.:"
        g \bar ":.|.:" a \bar "[|:" b \bar ":|][|:"
        c \bar ":|]" d \bar ":|." e \bar ":|:" f \bar ":|" g

      }
    }
    >>
  }
}
