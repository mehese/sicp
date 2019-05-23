#lang sicp

(define (unless condition 
                usual-value 
                exceptional-value)
  (if condition 
      exceptional-value 
      usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

; (factorial 5)→ ∞ loop. As all the arguments of unless need to be computed before running it
;  (unlike using cond or if) using unless will never get us out of a recursive loop the way
;  if and cond did.

; In  an normal-order language this should work as well as an if statement