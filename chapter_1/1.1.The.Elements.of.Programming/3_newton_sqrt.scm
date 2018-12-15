#lang sicp

(define TOL 1e-4)

(define (good-enough? guess x)
  (< (abs (- (* guess guess) x)) TOL))

(define (improve guess x)
  (/
   (+ guess (/ x guess))
   2))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(display (sqrt 2))
(display "\n")
(display (sqrt 3))
(display "\n")
(display (sqrt 4))
(display "\n")
(display (sqrt 49))
(display "\n")