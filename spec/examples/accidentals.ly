\version "2.18.2"

"//music" = \relative c {
  << \new Voice = "voice1" {
    \key d \major
    cis4 d e fis
    \key a \minor
    gis ais bes
    \key cis \minor
    cis dis e fis gis aes
    \key ees \major
    bes c d ees f fis g gis a
    %{accidental flags%}
    cis'! ees? g!8.
    %{alternative accidental/octave order%}
    ges,4 a'''2 b'4
    %{ficta%}
    bes
    \ficta ces bes2 \ficta g!4

    \key d \major
    dis des fisis f f

    \key bes \major
    dis e eeses e

    \key fis \minor
    fisis

    \key ees \major
    eeses
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
