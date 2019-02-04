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
(define (below-A  painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-up  (transform-painter 
                        painter1
                        split-point
                        (make-vect 1.0 0.5)
                        (make-vect 0.0 1.0)))
          (paint-down (transform-painter
                        painter2
                        (make-vect 0.0 0.0)
                        (make-vect 1.0 0.0)
                        split-point)))
      (lambda (frame)
        (paint-up frame)
        (paint-down frame)))))

(define (below-B  painter1 painter2)
  (rotate90 (beside
   (rotate270 painter1)
   (rotate270 painter2)
   )))


(display "Version A of") (newline)
(display "One wavy boi") (newline)
(display "One wavy boi") (newline)

(paint (below-A  wavy wavy))

(display "Version B of") (newline)
(display "One wavy boi") (newline)
(display "One wavy boi") (newline)

(paint (below-B  wavy wavy))