Lydown is a language and compiler for creating music scores, parts and snippets. The lydown code is compiled to [lilypond](http://lilypond.org/) code and then compiled to PDF, PNG or MIDI files.

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

The lydown command line tool can compile the code into lilypond code, PDF, PNG, or MIDI. The program creates an output file with the same name as the input file and the corresponding extension. Specifiying the -o switch causes the output to be opened immediately.

To create a PDF file:

    lydown -o --pdf helloworld.lydown

To create a MIDI file:

    lydown -o --midi helloworld.lydown

To create a lilypond file:

    lydown -o --ly helloworld.lydown

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

### Accidentals

Accidentals are entered using + and -

    8cgb-c2a => c8 g bb c a2

In lydown notes follow the key signature by default:

    - key: g major
    8g6fedcba2g => g8 fs16 e d c b a g2
    
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

Like in lilypond's [relative mode](http://www.lilypond.org/doc/v2.18/Documentation/notation/writing-pitches#relative-octave-entry), lydown uses ' and , for moving between octaves. The starting point is always c (that is c°).

### Barlines

Just like in lilypond, barlines are taken care of automatically according to the time signature. Final bar lines and repeat bar lines can be entered explicitly by using shorthand syntax:

    |: cege :|: cfaf :|
    
### Beams, slurs and ties

Lydown uses automatic beaming as the default, except in the case of vocal parts (see the section below on document settings). Auto beaming can be 

Beaming and sluring is similar to lilypond, except the beam/slur start comes before the note:

    8(cdef)g[6fe]4f => c8( d e f) g f16[ e] f4
    
a tie is written just like in lilypond:

    4g~6gfed2c => g4 ~ g16 f e d c2
    
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
    
Arbitrary expression marks can be entered as a string following a backslash (for placing it under the note) or a forward slash (for placing it above the note).

### Repeated articulation and rhythmic patterns: macros

An important feature of lydown is the macro, which facilitates rapid entry of repeated rhythmic and articulative patterns.

A common scenario is repeated articulation, for example a sequence of staccato notes:

    {_.}cdefgabc => c-. d-. e-. f-. g-. a-. b-. c-.

Another common scenario is a dotted rhythm:

    {8._6_}cdefgfed => c8. d16 e8. f16 g8. f16 e8. d16
    
A repeating diminution may also be expressed succintly:

    // the @ symbol denotes a repeated pitch
    {16_@@@}cfgf => c16 c c c f f f f g g g g f f f f 

A macro can also include both durations and articulation marks:

    {4_~6@_._._.}cdefgfed => c4 ~ c16 d-. e-. f-. g4 ~ g16 f-. e-. d-.

## Multiple parts

Things get a bit more exciting when multiple parts are present, such as in a piano score:

    \version "2.18.2"
    \score {
      \new PianoStaff <<
        \new Staff = "RH" \relative c' {
          \key c major
          \time 4/4
          c'8c g' g a a g4 f8 f e e d d c4
        }
        \new Staff = "LH" \relative c {
          \key c major
          \clef "bass"
          c4 e f e d8 b' c a f g c,4
        }
      >>
    }
    
Notice the curly braces, and the repeated key declarations. The lydown equivalent is a bit simpler (and also easier to input):

    - time: 4/4
    - key: c major
    - part: piano-right
    8c'cg'gaa4g 8ffeedd4c
    - part: piano-left
    4cefe 8db'cafg4c,

To compile and this example use the following command:

    lydown -o example1.lydown

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

## Adding a front cover

When creating professional scores and parts, it is customary to add a cover page, with the title of the piece, the composer's name and other general information. Lydown includes a 