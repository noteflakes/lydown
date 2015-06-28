- footnote syntax:

  cd [^"Is this note connected to the one before?"] d
  
  // override position (default is 0 . 1.5)
  cd [^"Is this note connected to the one before?"(-1 . 2)] d
  
  // Change the footnote number/sign (and string escaping)
  cd [^*"Is this \"note\" connected to the one before?"] d
  
- instead of command line modes, or in addition, an interactive mode:

  BWV247 sharon$ lydown
  Working directory: ~/repo/music/bach/BWV247
  > add mvmt 21-aria 2violins 2gambas alto continuo # add movement
  OK
  > watch 21-aria # watch directory
  ...
  ^C
  > cd 21-aria # go into subdirectory
  > watch # watch current directory
  ...
  ^C
  > score # compile and open score PDF
  > parts # compile and open part PDFs
  > gamba1 # compile and open gamba1 part
  > midi # compile and play midi

- a command line mode to create works and movements

  lydown mvmt 07-choral 2flutes 2oboes 3strings 2gambas choir* continuo
  
- refactor binary script (using _Thor_?)

  - extract command_line behavior into lib/lydown/cli.rb
  - put proofing mode into lib/lydown/cli/proof.rb
  - put movement create mode into lib/lydown/cli/create_movement.rb

- support for full work processing in command line tool
- support for movement filtering in command line tool
- support for part filtering in command line tool
- support for default output directory (/pdf) in command line tool

- markup before note:

  \\"_Jesus:_" cdef

- markup/expressions over barlines:

  8fe42c |\fermata

- include statements, both .ld and .ly files

  ly files are included before the music startst sta

- custom input modes
  - homophonic explode mode: chords split into multiple staves, with automatic ties (for recitativo accompagnato).

  2<adf+> ~ <bdg>

- multipart entry mode:

  - part: tenore, continuo
  - key: g minor

  4r8def+gad,
  1f+<6>

  b'bdb4gr
  g

- bar checks:

  (3)cdefg

- layout settings

  - layout:
    - paper: A4 landscape
    - margins: 10mm // all sides
    - margins: 1in 0.5in 1.5in 0.5in // all sides or top, right, bottom, left
    - ragged_bottom: true
    - ragged_last_bottom: true
    - ragged_right: true
    - ragged_last_right: true
    - score_staff_size: 17
    - part_staff_size: 20
    - between-system-space: 18mm
    // look at ripple _include files for more settings

- default preface page

- custom preface page (using include)

- titles

  - composer: Johann Sebastian Bach, Jr.
  - title: Markus Passion BWV 247
  - subtitle: Une reconstruction
  - subsubtitle:
  - copyright:
  - tagline:

- nested tuplets

  8%5/4{8fef8%efg}

  => \tuplet 5/4 { f8 e f \tuplet 3/2 { e[ f g] } }

- repeats:

  {: 4cdec :} {: 4ef2g :}

  => \\repeat volta 2 { c4 d e c } \\repeat volta 2 { e4 f g2 }

  {: 8ccg'gaa4g :: 8ffeedd4g :: 8ffeedd4c :}

  => \\repeat volta 2 { c8 c g' g a a g4 }
     \\alternative { { f8 f e e d d g4 | } { f8 f e e d d c4 | } }

  {X4: 4cdef :: 2ce :: 2fg :} 1c

  => \\repeat volta 4 { c4 d e f | }
     \\alternative { { c2 e | } { f2 g | } } c1

- support for figures on separate line

  arb-
  % 4<6>s<8>

  // or, with stream switching

  arb-
  =figures
  4<6>s<8>

- keyboard music:

  r: ...
  l: ...

- organ music:




- homophonic music (chords written on two lines)

  1= 4e8fd6ef8g4d
  2= cdbcdeb

  //=>
    <<
      { e4 f8 d ...}
      { c4 d8 e ...}
    >>

- grace notes

  8r$/6cd8e6[dc][ba][ge]8frd

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
