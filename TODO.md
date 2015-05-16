- support for full work processing in command line tool
- support for movement filtering in command line tool
- support for part filtering in command line tool
- support for default output directory (_pdf) in command line tool

music features:

- support for figures on separate line

  arb-
  % 4<6>s<8>

  // or, with stream switching

  arb-
  =figures
  4<6>s<8>

- support for (s)ilences.

  2s4ce

- multiple voices

  1: 8r6rg8.e6f8gc,f6ed
  2: 6dc8d6&b8c6&b8c6&8.b

  //=>
  <<
    {r8 r6 g ...}
    \\
    {d6 c d8 ...}
  >>

- homophonic music (chords written on two lines)

  1= 4e8fd6ef8g4d
  2= cdbcdeb

  //=>
    <<
      { e4 f8 d ...}
      { c4 d8 e ...}
    >>

- chords

  1<ace>2<ace>4<face>8.<ac>6<gce>
  // with expression
  1<ace>\prall\fermata 2<ace>.^ 4<face>... 8.<ac>\+\- 6<gce>\fermata\turn

- grace notes

  $6gab4c //=> \grace {g16 a b} 4c
  $^8d4c //=> \appoggiatura d8 c4
  $/8d4c //=> \acciaccatura d8 c4
  $\8d4c //=> \slashedGrace d8 c4
  4d$:6[cd]4c //=> \afterGrace d4 {c16[ d]} c4

  1= (1d\trill
  2= 2s4.s$6cd
  1c)

  //=>
    <<
      { d1^\trill_( }
      { s2 s4. \grace { c16 d } }
    >>

- support for general lilypond commands

  \stemDown $/6f\> \stemNeutral 4ge2c

  //=>
    \acciaccatura {
      \stemDown
      f16->
      \stemNeutral
    }
    g4 e c2

- spec for overriding beaming mode for parts.
