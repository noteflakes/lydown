#(define-markup-command (mm-feed layout props amount) (number?)
 (let ((o-s (ly:output-def-lookup layout 'output-scale)))
   (ly:make-stencil "" '(0 . 0) (cons 0 (abs (/ amount o-s))))))

segno = {
  \once \override Score.RehearsalMark.font-size = #-2
  \mark \markup { \musicglyph #"scripts.segno" }
}

segnobottom = {
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.font-size = #-2
  \mark \markup { \musicglyph #"scripts.segno" }
}

dalsegno = {
  \once \override Score.RehearsalMark.break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark.font-size = #-2
  \mark \markup { \fontsize #2 {"dal segno "} \musicglyph #"scripts.segno" }
}

dacapo = {
  \once \override Score.RehearsalMark.break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \mark \markup {\bold {\italic {"Da capo"}}}
}

dalsegnoadlib = {
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.self-alignment-X = #LEFT
  \once \override Score.RehearsalMark.font-size = #-2
  \mark \markup { \musicglyph #"scripts.segno" ad lib }
}

finedellaparteprima = {
  \once \override Score.RehearsalMark.break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \mark \markup {\bold {\italic {"Fine della parte prima"}}}
}

padbarlinebefore = {
  \once \override Staff.BarLine.extra-spacing-width = #'(-2 . 0)
}

padbarlineafter = {
  \once \override Staff.BarLine.extra-spacing-width = #'(0 . 2)
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
  \once \override AccidentalSuggestion.avoid-slur = #'outside
  \once \override AccidentalSuggestion.parenthesized = ##t
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
%     \override BassFigure.font-size = #-1
%     \override BassFigure.font-name = #"Georgia"
  }
  
}

#(define-markup-command (when-property layout props symbol markp) (symbol? 
markup?)
  (if (chain-assoc-get symbol props)
      (interpret-markup layout props markp)
      (ly:make-stencil empty-stencil)))
      
#(define-markup-command (apply-fromproperty layout props fn symbol)
  (procedure? symbol?)
  (let ((m (chain-assoc-get symbol props)))
    (if (markup? m)
        (interpret-markup layout props (fn m))
        empty-stencil)))

\header { tagline = ##f } % no tagline

setVerticalMargins = #(define-scheme-function
  (parser location top-staff top-markup bottom) (number? number? number?)
  #{
  \paper {
    top-system-spacing.basic-distance = #top-staff
    top-system-spacing.minimum-distance = #top-staff
    top-system-spacing.padding = -100 % negative padding to ignore skyline
    top-system-spacing.stretchability = 0 % fixed position

    top-markup-spacing.basic-distance = #top-markup
    top-markup-spacing.minimum-distance = #top-markup
    top-markup-spacing.padding = -100 % negative padding to ignore skyline
    top-markup-spacing.stretchability = 0 % fixed position

    last-bottom-spacing.basic-distance = #bottom
    last-bottom-spacing.minimum-distance = #bottom
    last-bottom-spacing.padding = -100 % negative padding to ignore skyline
    last-bottom-spacing.stretchability = 0 % fixed position
  }
  #}
)

halfBarline = {
  \once \hide Score.SpanBar
  \once \override Score.BarLine.bar-extent = #'(-1 . 1)
  \noBreak
  \bar "|"
}

scoreMode = #(define-void-function (parser location music) (scheme?)
  (if (eq? lydown:render-mode 'score)
    #{ #music #}
  ))
  
partMode = #(define-music-function (parser location music) (ly:music?)
  (if (eq? lydown:render-mode 'part)
    #{ #music #}
    #{ #}
  ))

#(define lydown:score-mode (eq? lydown:render-mode 'score))
#(define lydown:part-mode (eq? lydown:render-mode 'part))

\layout {
  % The OrchestraGroup is used in score mode as a wrapping context for staff
  % groups. It is based on the ChoirStaff in order to allow individual span
  % bars.
  \context {
    \ChoirStaff
    \name "OrchestraGroup"
    \accepts StaffGroup
    systemStartDelimiter = #'SystemStartBar
  }
  
  \context {
    \Score
    \accepts OrchestraGroup
  }
}

tacetScore = {
  \new Staff \with {
    \override StaffSymbol.staff-space = 0.001
    \override StaffSymbol.line-count = 1
    \override StaffSymbol.thickness = 0
    \override StaffSymbol.color = #(rgb-color 1 1 1)
    \remove "Time_signature_engraver"
    \remove "Clef_engraver"
  }
  { s4 }
}

% Shaping commands

sR = #(define-music-function (parser location r) (number?)
  #{ \once \override Slur.ratio = #r #}
)
sE = #(define-music-function (parser location e) (number?)
  #{ \once \override Slur.eccentricity = #e #}
)

sHL = #(define-music-function (parser location l) (number?)
  #{ \once \override Slur.height-limit = #l #}
)

sP = #(define-music-function (parser location p1 p2) (number? number?)
  #{ \once \override Slur.positions = #(cons p1 p2) #}
)

#(define (convert-shape-coords s)
  (map (lambda (v) (if (eq? v #f) '(0 . 0) v)) s)
)

sS = #(define-music-function (parser location s) (scheme?)
  #{ \once \shape #(convert-shape-coords s) Slur #}
)

knee = \once \override Beam.auto-knee-gap = #0