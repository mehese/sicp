#lang sicp

(define (abs-1 x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

(define (abs-2 x)
  (cond ((< x 0) (- x))
        (else x)))

(define (abs-3 x)
  (if (< x 0) (- x) x))

(write "Checking abs-1")

(abs-1 2)
(abs-1 0)
(abs-1 -5)
(= (abs-1 -3) 3)

(write "Checking abs-2")

(abs-2 -3)
(abs-2 0)
(abs-2 222)

(write "Checking abs-3")

(abs-3 -3)
(abs-3 0)
(abs-3 222)

;;; and, or, not

(define (>= x y)
  (or (> x y) (= x y)))

(define (<= x y)
  (not (> x y)))