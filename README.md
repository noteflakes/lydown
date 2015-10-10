Lydown is a language and compiler for creating music scores, parts and snippets. The lydown code is compiled to [lilypond](http://lilypond.org/) code and then compiled to PDF, PNG or MIDI files.

- [About](#about)
- [Installation](#installation)
- [Hello world in lydown](#hello-world-in-lydown)
- [Compiling the lydown code](#compiling-the-lydown-code)
- [Proofing mode](#proofing-mode)
- [Interactive mode](#interactive-mode)
- [The lydown syntax](#the-lydown-syntax)
	- [Notes and durations](#notes-and-durations)
	- [Accidentals](#accidentals)
	- [Octaves](#otaves)
	- [Barlines](#barlines)
	- [Rests](#rests)
	- [Beams, slurs and ties](#beams-slurs-and-ties)
	- [Articulation and expression marks](#articulation-and-expression-marks)
	- [Repeated articulation and rhythmic patterns: macros](#repeated-articulation-and-rhythmic-patterns-macros)
	- [Named macros](#named-macros)
	- [Clefs, key and time signatures](#clefs-key-and-time-signatures)
	- [Pickup bars](#pickup-bars)
	- [Lilypond Commands and inline settings](#lilypond-commands-and-inline-settings)
	- [Inline lyrics](#inline-lyrics)
	- [Stream switching](#stream-switching)
	- [Figured bass](#figured-bass)
- [Multiple parts](#multiple-parts)
- [Multiple movements](#multiple-movements)
- [Multiple voices](#multiple-voices)
- [Piano scores](#piano-scores)
- [multi-part scores and part extraction](#multi-part-scores-and-part-extraction)
- [Colla parte and part sources](#colla-parte-and-part-sources)
- [Mode specific code](#mode-specific-code)
- [Staff and system appearance](#staff-and-system-appearance)
- [Rendering MIDI && mp3 files](#rendering-midi-mp3-files)
- [Including files](#including-files)
  - [Including templates](#including-templates)
- [Adding a front cover](#adding-a-front-cover)


## About

Lydown builds on the ideas put forth by lilypond and makes the following improvements:

- a greatly simplified syntax for entering notes, for more rapid note entry and improved legibility.
- ability to enter lyrics and bass figures interspersed with the music.
- rhythmic macros for rapid entry of repeated rhythmic patterns.
- zero lilypond boilerplate code.
- a sane file/folder structure for creating multi-part, multi-movement works with automatic part extraction.

## Installation

Before installing lydown, you'll need to have installed [lilypond](http://lilypond.org/download.html).

You can verify that lilypond is correctly installed by running the following command:

    lilypond --version

If everything's ok, you can proceed by installing lydown:

    gem install lydown

and verifying that it too works:

    lydown --version

## Hello world in lydown

    // helloworld.lydown
    - key: d major
    - time: 2/4
    4d\"Hello world!" 6c#bag 3f#gag6f#d 4e

And here's the equivalent lilypond code:

    \version "2.18.2"
    relative c' {
      \key d major
      \time 2/4
       d'4\"Hello world!" cs16 b a g fs32 g a g fs16 d e4
    }

## Compiling the lydown code

The lydown command line tool can compile the code into lilypond code, PDF, PNG, or MIDI. The program creates an output file with the same name as the input file and the corresponding extension. Specifiying the -O switch causes the output to be opened immediately.

To create a lilypond file:

    lydown -O --ly helloworld.lydown

To create a PDF file:

    lydown -O --pdf helloworld.lydown

To create a PNG file:

    lydown -O --png helloworld.lydown

To create a MIDI file:

    lydown -O --midi helloworld.lydown


## Proofing mode

Lydown can be run in a special proofing mode designed to minimize the turnaround time between editing and viewing the result when entering new music or when editing existing music. To run lydown in proofing mode, use the proof subcommand:

    lydown proof
  
Lydown will then start to monitor all subdirectories and files in the current directory, and compile them whenever they're changed. Lydown will detect the lines that have changed and insert skip markers in order to speed up compilation and typeset only the music that has actually changed. In addition, notes in the bars that changed will be colored red.

In proof mode, lydown will generate parts and not a score. To include another part for reference along with the part that changed, you can use the include_parts parameter:

    lydown proof --include_parts continuo # or:
    lydown proof -i continuo

This is useful when editing baroque music for example, or when any other part can give context and aid in verifying the music.

## Interactive mode

When invoked without any parameters, an interactive lydown session is started. This mode is useful when working on music involving multiple movements or multiple parts. In this mode, you can move between directories, edit files (using vim), and compile specific movements or specific parts.

Just like in proofing mode, any changes you make to files within the working directory are immediately compiled and shown in the system viewer.

To get a list of available commands, type <code>help</code>.

## The lydown syntax

The lydown syntax is designed for faster note entry, better legibility and minimal boilerplate. The lydown syntax takes the basic ideas put forth by lilypond and simplifies them, with the following main differences:

- musical context (staves, parts, etc) is implicit rather than explicit.
- whitespace between notes is optional.
- durations come before notes.
- duration macros allow rapid entry of repeated rhythmic patterns (such as dotted rhythm).

It must be stressed that lydown is made to process music that is relatively simple, and it was designed to support the processing of baroque music in particular. Therefore, a lot of stuff that is possible with plain lilypond would not be possible with lydown.

For the sake of this tutorial, some familiarity with the concepts and syntax of lilypond is presumed. The lydown code will be shown alongside its lilypond equivalent.

### Notes and durations

In lydown, durations are entered before the note to which they refer, and they stay valid for subsequent notes, until a new value is entered:

    4c8de2f => c4 d8 e f2

In addition to the usual values (1, 2, 4, 8, 16, 32 etc), lydown adds two shortcuts for commonly used values: 6 for 16th notes and 3 for 32th notes:

    8c6de3fefefede2f => c8 d16 e f32 e f e f e d e f2

Augmentation dots are entered like in lilypond:

    8.c6d 8.e6f 2g => c8. d16 e8. f16 g2
    8..g 3g 4c => g8.. g32 c4
    
Notes can be repeated using the <code>@</code> placeholder:

    4c@@@ => c4 c c c

(The repeating note placeholder is useful when entering repeated notes with accidentals).

Chords are written using angled brackets, like in lilypond:

    (2<fd>4<ge>) => <f d>2( <g e>4)
    
### Accidentals

Accidentals can be entered using + and -

    8cgb-c2a => c8 g bes c a2

But can also be entered using the characters # for sharp, ß for flat and h for natural:

    c#dßeh => cis des e

In lydown notes follow the key signature by default:

    - key: g major
    ff#fhfßd#bß => fis fisis f f dis bes

The accidental mode can be changed by specifiying the manual accidental mode:

    - key: g major
    - accidentals: manual
    8g6f+edcba2g

In the default, automatic mode, when deviating from the key signature the accidental must be repeated for each note, regardless of barlines.

In the [same manner as lilypond](http://www.lilypond.org/doc/v2.18/Documentation/notation/writing-pitches#accidentals), accidentals can be forced by following the note name and accidental with a ! (for a reminder), or ? (for a cautionary accidental in parentheses):

      cc+c+!cc? => c cs cs! c c?

A ficta accidental (an non-original accidental that appears above the staff) can be entered using the ^ symbol after the accidental:

      cdef+^g

### Octaves

In Lydown, the first note in the document carries an absolute octave marker, using the <code>'</code> and <code>,</code> signs:

      c,,   // contrabass octave
      c,    // great octave
      c     // small octave
      c'    // first octave (middle c)
      c''   // second octave
      c'''  // third octave
      ...   // etc.

For the following notes, the octave markers <code>'</code> and <code>,</code> are used for jumping between octaves, using the same rules as 
 lilypond's [relative mode](http://www.lilypond.org/doc/v2.18/Documentation/notation/writing-pitches#relative-octave-entry):

### Barlines

Just like in lilypond, barlines are taken care of automatically according to the time signature. Final bar lines and repeat bar lines can be entered explicitly by using shorthand syntax:

    |: cege :|: cfaf :|

When entering unmetered music, an invisible barline can be added in order to provide line breaks:

    -time: unmetered
    cdef ?| gag

### Rests

Normal rests are written [like in lilypond](http://www.lilypond.org/doc/v2.18/Documentation/notation/writing-rests#rests):

    4ce2r => c4 e r2

Full bar rests are [similar to lilypond](http://www.lilypond.org/doc/v2.18/Documentation/notation/writing-rests#full-measure-rests), except there's no need to enter the rest value (it is implicit in the time signature):

    - time: 3/4
    // 4 bar rest in the middle
    2c4e R*4 2.g

### Beams, slurs and ties

Lydown uses automatic beaming as the default, except in the case of vocal parts (see [document settings](#settings)). Auto beaming can be

Beaming and sluring is similar to lilypond, except the beam/slur start comes before the note:

    8(cdef)g[6fe]4f => c8( d e f) g f16[ e] f4

a regular tie is written just like in lilypond:

    4g~6gfed2c => g4 ~ g16 f e d c2

Lydown also supports a shortened tie form, where the tied note is not repeated:

    4g6&fed2c => g4 ~ g16 f e d c2

### Articulation and expression marks

Lilypond [shorthand articulation marks](http://www.lilypond.org/doc/v2.18/Documentation/notation/expressive-marks-attached-to-notes#articulations-and-ornamentations) can be entered after a backslash

    c\^ e\+ g\_ => c-^ e-+ g-_

Common articulation marks can be entered immediately after the note:

    // tenuto, staccato, staccatissimo
    c_e.g` => c-- e-. g-!

Other arbitrary lilypond articulations can be entered after a backslash:

    c\staccato e\mordent g\turn => c\staccato e\mordent g\turn

[Dynamic marks](http://www.lilypond.org/doc/v2.18/Documentation/notation/expressive-marks-attached-to-notes#dynamics) are entered before the note to which they apply:

    c\f eg

    \f cege \p cfaf => c\f e g e c\p f a f

Arbitrary expression markup can be entered as a string following a backslash. Lydown supports basic markdown syntax for formatting the expression:

    c\"hello" // displayed above the note
    c\_"hello" // displayed below the note
    c\<"hello" // right-aligned
    c\|"hello" // centered
    c\_|"hello" // centered, below the note
    c\"_hello_" // italic
    c\"__hello__" // bold

### Repeated articulation and rhythmic patterns: macros

An important feature of lydown is the macro, which facilitates rapid entry of repeated rhythmic and articulative patterns.

A common scenario is repeated articulation, for example a sequence of staccato notes:

    {.}cdefgabc => c-. d-. e-. f-. g-. a-. b-. c-.

A macro can also contain a fully qualified lilypond articulation specifier:

    {\tenuto}cege => c\tenuto e\tenuto g\tenuto e\tenuto

Rhythmic macros can be used for repeated rhythmic patterns. A common scenario is a dotted rhythm:

    // The _ symbol denotes a note placeholder
    {8._6_}cdefgfed => c8. d16 e8. f16 g8. f16 e8. d16

A repeating diminution may also be expressed succintly:

    // The @ symbol denotes a repeated pitch
    {16_@@@}cfgf => c16 c c c f f f f g g g g f f f f

A macro can include both durations and articulation marks:

    {4_~6@(_._._.)}cdefgfed => c4 ~ c16 d-.( e-. f-.) g4 ~ g16 f-.( e-. d-.)

A macro containing durations will remain valid until another duration or duration macro is encountered. A macro containing articulation only will be valid until another duration, macro or empty macro is encountered:

    6{.}gg{}aa => g16-. g-. a a

### Named macros

Macros can be defined with a name and reused:

    - macros:
      - dotted: 8._6_
    {dotted}gaba2g{dotted}abcb2a => g8. a16 b8. a16 g2 a8. b16 c8. b16 a2

### Clefs, key and time signatures

Clefs are determined automatically by lydown based on the specified part. In case no part is specified, the default clef is a treble clef. The clef values are the same as in [lilypond](http://www.lilypond.org/doc/v2.18/Documentation/notation/displaying-pitches#clef). The clef can be changed at any time with a clef setting:

    - clef: bass
    8cdefgabc
    - clef: tenor
    defedcbd
    - clef: bass
    1c

Key and time signatures are entered inline as document settings ([see below](#settings)). The [key](http://www.lilypond.org/doc/v2.18/Documentation/notation/displaying-pitches#key-signature) and [time](http://www.lilypond.org/doc/v2.18/Documentation/notation/displaying-rhythms#time-signature) values follow the lilypond syntax:

    - key: d major
    - time: 3/4

In the case of key signatures, accidentals will follow the lydown syntax:

    - key: b- major
    - key: f+ minor
    
Key signatures can also be specified using shorthand notation (upper case for major, lower case for minor):

    - key: B- // b flat major
    - key: f+ // f sharp minor

The default key signature is C major, and the default time signature is 4/4.

Key or time signatures can be changed on the fly:

    - time: 4/4
    4c e g b
    - time: 3/4
    c e g 2.c
    
### Pickup bars

[Pickup bars](http://www.lilypond.org/doc/v2.18/Documentation/notation/displaying-rhythms#upbeats) (anacrusis, upbeat) are defined with the pickup setting:

    - time: 3/4
    - pickup: 4
        4g
    c8cdcb4aaa
    d8dedc4bb

### Lilypond Commands and inline settings

Lilypond commands and settings can be entered inline as part of the note stream:

  cd \key:E- e \stemDown f
  
A useful shorthand is for one-time (<code>\once</code>) overrides, with an exclamation mark between the backslash and the command:

  \!override:"NoteHead.color = #red"

Multiple arguments can be given, separated by colons. Arguments need to be quoted only if they contain whitespace, or colons:

  \!override:AccidentalSuggestion:"#'avoid-slur = #'outside"

Some lilypond command arguments are expected to be quoted. Quotes can be escaped by prefixing them with a backslash:

  \footnote:"#'(-1 . 1)":"\"slurred?\""

### Inline lyrics

Lyrics for vocal parts can be entered on separate lines prefixed by a > symbol:

    4c[8de]4fd(4c[8de]2f)
    > Ly-down is the bomb__

Or between notes using quotes:

    4c[8de]4fd(4c[8de]2f) >"Ly-down is the bomb__"

Text alignment follows the duration, beaming and slurring of the music, [just like in lilypond](http://www.lilypond.org/doc/v2.18/Documentation/notation/common-notation-for-vocal-music#automatic-syllable-durations). Sillables are expected to be separated by a dash. Melismas, i.e. a single sillable streched over multiple notes, is signified by one or more underscores.

Multiple stanzas for the same music can be specified by including the stanza number in parens:

    4cege1c
    > Ly-down is the bomb.
    >(2) Li-ly-pond is too.

### Stream switching

Lyrics can be entered in a block, before or after musical notation, by switching streams:

    8ccg'gaa4g
    8ffeedd4c
    =lyrics
    Twin-kle twin-kle lit-tle star,
    How I won-der what you are.
    =music
    8g'gffeed4
    ...
    
Multiple lyrics stanzas can be written by including the stanza number in parens:

    =lyrics(1) // optional, same as =lyrics
    ...
    =lyrics(2)
    ...

### Figured bass

Figured bass is entered inline, following notes or even between notes, when
multiple figures align with a single note.

    c<6>de<5>c // figures are automatically rhythmically aligned 
    e<7`> // barred figure
    f<6+> // sharp 6th
    g<6-> // flat 6th
    g<6!> // natural sixth
    a<h> // natural third
    a<#> // sharp third
    a<b> // flat third
    b<7#>b<6_> // extender (tenue) line on sharp third
    1c2<6><7-> // use durations to change figures over a long note
    1c2<><7-> // <> is an empty figure
    c<->dec<.> // extender (tenue) line without figures over the four notes

## Multiple parts

Multiple parts can be entered in the same file by prefixing each part's content with a -part setting:

    - part: violino1
    8c'cg'gaa4g
    - part: continuo
    4cefe

## Multiple movements

For multi-movement works, prefix each movement with a -movement setting:

    - movement: Adagio
    ...
    - movement: Allegro
    ...

## Multiple voices

[Multiple voices](http://www.lilypond.org/doc/v2.18/Documentation/notation/multiple-voices#single_002dstaff-polyphony) on the same staff can be easily entered using the following notation:

    1: 8egfdeg4f 2: 4cded u: ...
    
the <code>u:<\code> command is used to return to single voice (_unisono_) mode.
  
Lyrics can be added for individual voices by using inline lyrics:

    1: ceg >"yeah yeah yeah" 2: gbd >"no no no" u: ...

## Piano scores

[Piano/keyboard scores](http://www.lilypond.org/doc/v2.18/Documentation/notation/common-notation-for-keyboards) can be created by using the <code>r/l</code> (right/left) prefixes:

    r: 8cdeccdec
    l: 4cgcg

In order to jump between staves, you can use the special commands <code>\r, \l</code>

    r: 8<e'c'> \l g,f+g \r <g'' c'> \l e,,d+e \r
    l: 1s

## multi-part scores and part extraction

As the example above shows, lydown supports multiple parts in the same file, but parts can also be written in separate files. This is useful for long pieces or those with a large number of parts.

For this we create a main file which defines the score structure:

// score.lydown
- score:
   - [violino1, violino2]
   - viola
   - violoncello
- time: 4/4
- key: c major

Then we enter the music in a separate file for each part:

// violino1.lydown
8c''cg'gaa4g 8ffeedd4c

And so forth.

To compile the score, we use the following command:

lydown -o -s score.lydown

To extract a specific part, we use the -p  switch:

lydown -o -p violino1 score.lydown

## Colla parte and part sources

lydown provides two ways to reuse a part's music in another part. The first is by defining a part source:

    - parts:
      - violino1:
        - source: soprano

When dealing situations such as a choral being doubled by many instruments, a more convenient approach would be the <code>colla_parte</code> setting:

    - colla_parte:
      - soprano: violino1, flute1, flute2, oboe1
      - alto: violino2, oboe2
      - tenor: viola, gamba1
      - basso: gamba2

It is important to remember that the <code>colla_parte</code> setting is the opposite of the part source. Instead of defining a source for a part, it defines the parts that follow the source part.

## Including another part when extracting parts

When extracing parts, some cases, such as recitatives, require displaying another part together with the part to be extracted. Parts can be included in extracted parts using the <code>include_parts</code> setting:

    - parts:
      - continuo:
        - include_parts: tenore
        
multiple parts can be specified by comma separating them.

## Mode specific code

The <code>\mode</code> and <code>\nomode</code> commands can be used to render code for specific modes. This can be useful when the extracted part should display a different music than the score. The mode command causes anything after it to be rendered only when the rendering mode matches the specified mode.

    \mode:score 4cege \mode:part 4cded \mode:none 1c
    
The example above will be render as <code>4cege1c</code> when in score mode, and as <code>4cded1c</code> in the extracted part.

To cancel a mode, use either <code>\mode:none</code> or <code>\nomode</code>

## Staff and system appearance

Numerous settings can be used to control the way staves and systems are displayed. Normally, lydown will follow standard conventions when putting together a score: the different parts will be ordered correctly (e.g. flutes, then oboes, then strings, then vocal parts, then continuo), and braced/bracketed according to convention.

When a single movement switches between different ensembles, for example a recitativo secco followed by a recitativo accompagnato, empty staves may be hidden using setting <code>empty_staves</code> setting:

    - empty_staves: hide
    
Normally, instrument names are shown according to convention, to the left of each staff in the first system. To hide the instrument names on the first system, use the <code>instrument_names</code> setting:

    - instrument_names: hide
    
The <code>instrument_names</code> setting can also be set to <inline>, in which case the instrument name will be displayed above the beginning of each staff in the first system.
  
To show the instrument name inline at any point in the music, use the <code>\instr</code> command:

    - part: flute
    R*4
    // when no parameter is given, the part name is used, 
    // and engraved capitalized with numbers formatted to roman numerals
    \instr 4c8eg2c
    ...
    // when the instrument name is specifed, it is used in place of the 
    // part name:
    \instr:"Flute II" 4c8eg2c
    
The <code>\instr</code> command can also accept an alignment modifier:

    \<instr // right-aligned
    \>instr // left-aligned (default)
    \|instr // centered

Another setting which controls the display of instrument names is <code>instrument_name_style</code> which can be set to <code>normal</code> or <code>smallcaps</code>, in which case the instrument name will be engraved using small caps.

## Rendering MIDI && mp3 files

In order to render the source code into MIDI, the midi format should be specified:

    lydown --midi score.ld
    
The playback tempo can be specified either using the <code>midi_tempo</code> setting:

    - midi_tempo: 4=96
    
Or inline using the <code>tempo</code> command, putting the tempo in parens:

    \tempo:(4=120)
    cdef
    /tempo:(4=54)
    gabc

Rendering of mp3 files requires both [timidity](http://timidity.sourceforge.net/) and [LAME](http://lame.sourceforge.net/) to be installed.

## Including files

Lilypond files can be included into the generated lilypond code by using <code>include</code> settings:

    - include: abc.ly

Multiple files can be included by adding an include setting for each file. Mode-specific include files can be defined by nesting include statements inside of <code>score</code> or <code>parts</code> settings:

    - score:
      - include: def.ly // included only in score mode
    - parts:
      - include: ghi.ly // included only in part mode

The include statements are placed inside of a movement's score block as lilypond [\include](http://lilypond.org/doc/v2.19/Documentation/notation/including-lilypond-files.html) commands, so for each movement different includes can be defined.

To place includes at the beginning of the lilypond document, includes should be defined under the <code>document</code> setting:

    - document:
      - include: def.ly // this will be included at the top of the lilypond doc

Pathnames are relative to the lydown source file.

### Including templates

In addition to including normal lilypond files, Lydown also supports the rendering of templates into the generated lilypond doc, by using the <code>.ely</code> extension. The templates should be written using Ruby's [ERB](http://www.stuartellis.eu/articles/erb/) syntax, and are supplied with the lydown context object as <code>self</code>. A trivial example:

    \markup {
      % will output either 'score' or 'part' according to the rendering mode
      <%= self.render_mode %> 
    }

## Adding a front cover

To be continued...