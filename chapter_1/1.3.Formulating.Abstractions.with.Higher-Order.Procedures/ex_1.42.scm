#lang sicp

(define square (lambda (x) (* x x)))

(define (compose f g)
  (lambda (x) (f (g x))))

((compose inc inc) 0) ; (x + 1) + 1 
((compose inc (lambda (x) (* 2 x)) ) 1) ; 2x + 1
((compose square inc) 6) ; 49 ✔

