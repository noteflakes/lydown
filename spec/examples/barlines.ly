\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    c1 \bar "|" d \bar "." e \bar "||" f \bar ".|"
    g \bar ".." a \bar "|.|" b \bar "|."

    c \bar ".|:" d \bar ":..:" e \bar ":|.|:" f \bar ":|.:"
    g \bar ":.|.:" a \bar "[|:" b \bar ":|][|:"
    c \bar ":|]" d \bar ":|." e \bar ":|:" f \bar ":|." g \bar "" a
  } >>
}

\book {
  \header {
  }

  \bookpart {
    \score {
      \new OrchestraGroup \with { } <<
        \new StaffGroup \with { \consists "Bar_number_engraver" } <<
          <<
          \new Staff = Staff \with { }
          \context Staff = Staff {
            \"//music"
          }
          >>
        >>
      >>
      \layout { }
    }
  }
}
