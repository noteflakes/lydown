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
    \override Stem.thickness = #2
    
    % slurs and ties are a bit curvier and thicker
    % ties are also a bit more distant from note heads
    % all that with a bit of randomness
    \override Slur.eccentricity = #(lambda (grob) (* 0.05 (random:normal)))
    \override Slur.height-limit = #(lambda (grob) (+ 2.8 (* 0.2 (random:normal))))
    \override Slur.thickness = #(lambda (grob) (+ 2.9 (* 0.1 (random:normal))))
    \override Slur.ratio = #(lambda (grob) (+ 0.3 (* 0.05 (random:normal))))

    \override Tie.thickness = #(lambda (grob) (+ 2.9 (* 0.1 (random:normal))))
    \override Tie.ratio = #(lambda (grob) (+ 0.3 (* 0.05 (random:normal))))
    \override Tie #'details #'note-head-gap = #(lambda (grob) (+ 0.5 (* 0.1 (random:normal))))
    
    \override Beam.beam-thickness = #(lambda (grob) (+ 0.55 (* 0.02 (random:normal))))
    \override Beam.length-fraction = #1.15
    
%     \remove "Bar_number_engraver"
  }
  
  \context {
    \Staff
    \override StaffSymbol.color = #(rgb-color 0.25 0.2 0.2)
    
  }
  
  \context {
    \Lyrics
    % candidates: Georgia, Hoefler Text, Hoefler Text Italic,
    % 
    \override LyricText #'font-name = #"Hoefler Text"
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

% override the figured bass formatter in order to fix size of figure accidentals
#(define-public (better-format-bass-figure figure event context)
  (let* ((fig (ly:event-property event 'figure))
         (fig-markup (if (number? figure)

                         ;; this is not very elegant, but center-aligning
                         ;; all digits is problematic with other markups,
                         ;; and shows problems in the (lack of) overshoot
                         ;; of feta-alphabet glyphs.
                         ((if (<= 10 figure)
                              (lambda (y) (make-translate-scaled-markup
                                           (cons -0.7 0) y))
                              identity)

                          (cond
                           ((eq? #t (ly:event-property event 'diminished))
                            (markup #:slashed-digit figure))
                           ((eq? #t (ly:event-property event 'augmented-slash))
                            (markup #:backslashed-digit figure))
                           (else (markup #:number (number->string figure 10)))))
                         #f))

         (alt (ly:event-property event 'alteration))
         (alt-markup
          (if (number? alt)
              (markup
               #:general-align Y DOWN #:fontsize
               (if (not (= alt DOUBLE-SHARP))
                   0 2)
               (alteration->text-accidental-markup alt))
              #f))

         (plus-markup (if (eq? #t (ly:event-property event 'augmented))
                          (markup #:number "+")
                          #f))

         (alt-dir (ly:context-property context 'figuredBassAlterationDirection))
         (plus-dir (ly:context-property context 'figuredBassPlusDirection)))

    (if (and (not fig-markup) alt-markup)
        (begin
          (set! fig-markup (markup #:left-align #:pad-around 0.2 alt-markup))
          (set! alt-markup #f)))


    ;; hmm, how to get figures centered between note, and
    ;; lone accidentals too?

    ;;    (if (markup? fig-markup)
    ;;  (set!
    ;;   fig-markup (markup #:translate (cons 1.0 0)
    ;;                      #:center-align fig-markup)))

    (if alt-markup
        (set! fig-markup
              (markup #:put-adjacent
                      X (if (number? alt-dir)
                            alt-dir
                            LEFT)
                      fig-markup
                      #:pad-x 0.2 #:lower 0.1 alt-markup)))

    (if plus-markup
        (set! fig-markup
              (if fig-markup
                  (markup #:put-adjacent
                          X (if (number? plus-dir)
                                plus-dir
                                LEFT)
                          fig-markup
                          #:pad-x 0.2 plus-markup)
                  plus-markup)))

    (if (markup? fig-markup)
        (markup #:fontsize 0 fig-markup)
        empty-markup)))

\layout {        
  \context { 
    \FiguredBass 
    figuredBassFormatter = #better-format-bass-figure
%     \override BassFigure #'font-name = #"Georgia"
  }
}
