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

prallupbefore = {
  \mark\markup {
    \musicglyph #"scripts.prallup"
    \hspace #1 
  }
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
        
