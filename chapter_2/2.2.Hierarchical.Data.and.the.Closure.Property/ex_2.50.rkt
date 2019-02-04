#lang racket

(#%require sicp-pict)

(display "One wavy boi") (newline)

(define wavy
  (segments->painter
   (list
    (make-segment (make-vect .25 0) (make-vect .35 .5)) 
    (make-segment (make-vect .35 .5) (make-vect .3 .6)) 
    (make-segment (make-vect .3 .6) (make-vect .15 .4)) 
    (make-segment (make-vect .15 .4) (make-vect 0 .65)) 
    (make-segment (make-vect 0 .65) (make-vect 0 .85)) 
    (make-segment (make-vect 0 .85) (make-vect .15 .6)) 
    (make-segment (make-vect .15 .6) (make-vect .3 .65)) 
    (make-segment (make-vect .3 .65) (make-vect .4 .65)) 
    (make-segment (make-vect .4 .65) (make-vect .35 .85)) 
    (make-segment (make-vect .35 .85) (make-vect .4 1)) 
    (make-segment (make-vect .4 1) (make-vect .6 1)) 
    (make-segment (make-vect .6 1) (make-vect .65 .85)) 
    (make-segment (make-vect .65 .85) (make-vect .6 .65)) 
    (make-segment (make-vect .6 .65) (make-vect .75 .65)) 
    (make-segment (make-vect .75 .65) (make-vect 1 .35)) 
    (make-segment (make-vect 1 .35) (make-vect 1 .15)) 
    (make-segment (make-vect 1 .15) (make-vect .6 .45)) 
    (make-segment (make-vect .6 .45) (make-vect .75 0)) 
    (make-segment (make-vect .75 0) (make-vect .6 0)) 
    (make-segment (make-vect .6 0) (make-vect .5 .3)) 
    (make-segment (make-vect .5 .3) (make-vect .4 0)) 
    (make-segment (make-vect .4 0) (make-vect .25 0)) 
    )))

(paint wavy)

;; Implementation
(define (flip-horiz painter)
  (transform-painter
   painter
   (make-vect 1.0 0.0)   ; new origin
   (make-vect 0.0 0.0)   ; new end of edge1
   (make-vect 1.0 1.0))) ; new end of edge2

(define (rotate180 painter)
  ;; flip-vert copy-pasted
  (transform-painter 
   painter
   (make-vect 0.0 1.0)   ; new origin
   (make-vect 1.0 1.0)   ; new end of edge1
   (make-vect 0.0 0.0))) ; new end of edge2

(define (rotate270 painter)
  ;; mirror the 90 degree rotation
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)
                     ))

(display "iob yvaw enO") (newline)
(paint (flip-horiz wavy))

(display "rotate180") (newline)
(paint (rotate180 wavy))

(display "rotate270") (newline)
(paint (rotate270 wavy))