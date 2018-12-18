#lang sicp

(define TOL 0.001)

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (improve y x)
  (/
   (+ (/ x (square y)) (* 2 y))
   3))

(define (close-enough x y)
  ;(display (cons x (cons y (abs (- (/ y x) 1)))))
  ;(newline)
  (<
   (abs (- (/ y x) 1))
   TOL))

(define (cube-root-iter guess x)
  (define new-guess (improve guess x))
  (if (close-enough new-guess guess)
      new-guess
      (cube-root-iter new-guess x)))

(define (cube-root x)
  (cube-root-iter 1.0 x))

(cube-root 8.0)
(cube-root 27.0)
(cube-root (* 4.23 4.23 4.23))
(cube-root (* 14.5 14.5 14.5))