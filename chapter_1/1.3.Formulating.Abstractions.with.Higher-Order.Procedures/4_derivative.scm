#lang sicp

(define square (lambda (x) (* x x)))

(define cube (lambda (x) (* x x x)))

(define dx 0.00001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define e-to-x (lambda (x) (expt 2.71828 x)))

((deriv square) 5)
((deriv cube) 5)
(list ((deriv e-to-x) 5) (expt 2.71828 5)) ; the two should be roughly equal
