\header {
  tagline = \markup {
    Engraved using \bold {
      \with-url #"http://github.com/ciconia/lydown" {
        Lydown
      }
    }
    and \bold {
      \with-url #"http://lilypond.org/" {
        Lilypond
      }
    }
  }
}

segno = {
  \once \override Score.RehearsalMark #'font-size = #-2
  \mark \markup { \musicglyph #"scripts.segno" }
}

segnobottom = {
  \once \override Score.RehearsalMark #'direction = #DOWN
  \once \override Score.RehearsalMark #'font-size = #-2
  \mark \markup { \musicglyph #"scripts.segno" }
}

dalsegno = {
  \once \override Score.RehearsalMark #'break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark #'direction = #DOWN
  \once \override Score.RehearsalMark #'self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark #'font-size = #-2
  \mark \markup { \fontsize #2 {"dal segno "} \musicglyph #"scripts.segno" }
}

dacapo = {
  \once \override Score.RehearsalMark #'break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark #'direction = #DOWN
  \once \override Score.RehearsalMark #'self-alignment-X = #RIGHT
  \mark \markup {\bold {\italic {"Da capo"}}}
}

dalsegnoadlib = {
  \once \override Score.RehearsalMark #'direction = #DOWN
  \once \override Score.RehearsalMark #'self-alignment-X = #LEFT
  \once \override Score.RehearsalMark #'font-size = #-2
  \mark \markup { \musicglyph #"scripts.segno" ad lib }
}

editF = \markup { \center-align \concat { \bold { \italic ( }
  \dynamic f \bold { \italic ) } } }
editP = \markup { \center-align \concat { \bold { \italic ( }
  \dynamic p \bold { \italic ) } } }
editPP = \markup { \center-align \concat { \bold { \italic ( }
  \dynamic pp \bold { \italic ) } } }
  
doux = \markup { \center-align \bold { \italic doux }}
fort = \markup { \center-align \bold { \italic fort }}

ten = \markup { \italic ten. }

ficta = {
  \once \override AccidentalSuggestion #'avoid-slur = #'outside
  \once \set suggestAccidentals = ##t
}

%{
  http://www.lilypond.org/doc/v2.18/Documentation/snippets/editorial-annotations#editorial-annotations-adding-links-to-objects
%}
#(define (add-link url-strg)
  (lambda (grob)
    (let* ((stil (ly:grob-property grob 'stencil)))
      (if (ly:stencil? stil)
        (begin
          (let* (
             (x-ext (ly:stencil-extent stil X))
             (y-ext (ly:stencil-extent stil Y))
             (url-expr (list 'url-link url-strg `(quote ,x-ext) `(quote ,y-ext)))
             (new-stil (ly:stencil-add (ly:make-stencil url-expr x-ext y-ext) stil)))
          (ly:grob-set-property! grob 'stencil new-stil)))
        #f))))
        

\layout {
  #(layout-set-staff-size 14)
  indent = 0\cm

  \context {
    \Score
    \override InstrumentName #'self-alignment-X = #right
    \override InstrumentName #'padding = 0.6
    
    \override BarNumber #'padding = 1.5
    
    %make note stems a bit thicker
    \override Stem.thickness = #1.5
    
    % slurs and ties are a bit curvier and thicker
    % ties are also a bit more distant from note heads
    % all that with a bit of randomness
    \override Slur.eccentricity = #(lambda (grob) (* 0.05 (random:normal)))
    \override Slur.height-limit = #(lambda (grob) (+ 2.8 (* 0.2 (random:normal))))
    \override Slur.thickness = #(lambda (grob) (+ 2.85 (* 0.1 (random:normal))))
    \override Slur.ratio = #(lambda (grob) (+ 0.3 (* 0.05 (random:normal))))

    \override Tie.thickness = #(lambda (grob) (+ 2.85 (* 0.1 (random:normal))))
    \override Tie.ratio = #(lambda (grob) (+ 0.3 (* 0.05 (random:normal))))
    \override Tie #'details #'note-head-gap = #(lambda (grob) (+ 0.5 (* 0.1 (random:normal))))
    
%     \remove "Bar_number_engraver"
  }
  
  \context {
%     \Lyrics
%     \override LyricText #'font-name = #"Arial"
%     \override LyricText #'font-size = #3
  }
}

\paper {
%   #(set-default-paper-size "A5")
  
%   system-system-spacing #'basic-distance = #17
  
  top-margin = 1.4\cm
  bottom-margin = 1.4\cm
  two-sided = ##t
  inner-margin = 1.4\cm
  outer-margin = 2\cm
  
  markup-system-spacing #'padding = #3
}

% trill = #(make-articulation "stopped")
trillSharp = #(make-articulation "trillSharp")
trillNatural = #(make-articulation "trillNatural")
tr = #(make-articulation "t")
trillSug = #(make-articulation "trillSug")
prallSug = #(make-articulation "prallSug")
arcTrill = #(make-articulation "arcTrill")
arcDot = #(make-articulation "arcDot")
arcArc = #(make-articulation "arcArc")
arcArcDot = #(make-articulation "arcArcDot")
dotDot = #(make-articulation "dotDot")
dotPrall = #(make-articulation "dotPrall")
dotDoublePrallDoublePrall = #(make-articulation "dotDoublePrallDoublePrall")
doublePrall = #(make-articulation "doublePrall")

prallupbefore = {
  \mark\markup {
    \musicglyph #"scripts.prallup"
    \hspace #1 
  }
}

