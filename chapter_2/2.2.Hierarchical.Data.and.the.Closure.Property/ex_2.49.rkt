#lang racket

(#%require sicp-pict)

;; Using previous contstructors and selectors will mess up the segments->painter
;;  procedure included in the package. Also, #lang sicp pops an error when calling paint
(define outline
  (segments->painter
   (list
    (make-segment (make-vect 0.0 0.0) (make-vect 0.0 1.0))
    (make-segment (make-vect 0.0 1.0) (make-vect 1.0 1.0))
    (make-segment (make-vect 1.0 1.0) (make-vect 1.0 0.0))
    (make-segment (make-vect 1.0 0.0) (make-vect 0.0 0.0))
    )))

(display "Outline") (newline)

(paint outline)

(display "X marks the spot") (newline)

(define X
  (segments->painter
   (list
    (make-segment (make-vect 0.0 0.0) (make-vect 1.0 1.0))
    (make-segment (make-vect 0.0 1.0) (make-vect 1.0 0.0))
    )))

(paint X)

(display "Diamonds are forever") (newline)

(define lou-diamond-phillips
  (segments->painter
   (list
    (make-segment (make-vect 0.5 0.0) (make-vect 1.0 0.5))
    (make-segment (make-vect 1.0 0.5) (make-vect 0.5 1.0))
    (make-segment (make-vect 0.5 1.0) (make-vect 0.0 0.5))
    (make-segment (make-vect 0.0 0.5) (make-vect 0.5 0.0))
    )))

(paint lou-diamond-phillips)

(display "Some people have too much time on their hands") (newline)
(paint
  (segments->painter
   (list
    (make-segment (make-vect 0.20 0.00) (make-vect 0.35 0.50))
    (make-segment (make-vect 0.35 0.50) (make-vect 0.30 0.60))
    (make-segment (make-vect 0.30 0.60) (make-vect 0.15 0.45))
    (make-segment (make-vect 0.15 0.45) (make-vect 0.00 0.60))
    (make-segment (make-vect 0.00 0.80) (make-vect 0.15 0.65))
    (make-segment (make-vect 0.15 0.65) (make-vect 0.30 0.70))
    (make-segment (make-vect 0.30 0.70) (make-vect 0.40 0.70))
    (make-segment (make-vect 0.40 0.70) (make-vect 0.35 0.85))
    (make-segment (make-vect 0.35 0.85) (make-vect 0.40 1.00))
    (make-segment (make-vect 0.60 1.00) (make-vect 0.65 0.85))
    (make-segment (make-vect 0.65 0.85) (make-vect 0.60 0.70))
    (make-segment (make-vect 0.60 0.70) (make-vect 0.75 0.70))
    (make-segment (make-vect 0.75 0.70) (make-vect 1.00 0.40))
    (make-segment (make-vect 1.00 0.20) (make-vect 0.60 0.48))
    (make-segment (make-vect 0.60 0.48) (make-vect 0.80 0.00))
    (make-segment (make-vect 0.40 0.00) (make-vect 0.50 0.30))
    (make-segment (make-vect 0.50 0.30) (make-vect 0.60 0.00)))))