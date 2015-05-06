- correct clefs, beaming mode for different parts
- A movement should be enclosed with a \bookPart

music features:
- support for (s)ilences.

  2s4ce

- figured bass:

  % /2 s /8 7- 6 /4 5
  % /2 642 /8 s /32 s /16. 65- /4 s
  % /32 s /16. 64 /8 s s 75 /2 6
  % 5 /4 s /8 68 5-7
  % 95' 86 /4 75- /2 6`
  % s /4 7-5 6
  % /2 s 64'2
  % s /4 6 642
  % /8 s 642' h 4'2 6 6` b 6
  % 7 6 /4 h /2 6
  % 6 /4 53 4'2
  % s /8 6 6b 7 5' 45 64'2
  % /1 6
  % /2 7# 64'2
  % s /4 65 7-_
  % /4 s 6 6- /8 4' 5
  % /4 s /8 64 5'# 5 6` _ 5
  % /4 6` 5 /2 5'
  % s 6`4'2'
  % s 7-5
  % /1 5'
  % /2 6`4'2 /4 6 /8 6`4 5'#
  % /1 8#
  % /2 7# 6`5-
  % s 6
  % 6` 65 
  % s /8 s 6 6 64
  % 64'2 6 75 /16 8# 7_ /8 3 742 64 5#

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
