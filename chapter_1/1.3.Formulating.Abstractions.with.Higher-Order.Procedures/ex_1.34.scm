#lang sicp

(define square (lambda (x) (* x x)))

(define (f g) (g 2))

(f square) ; (square 2) -> 4

(f (lambda (z) (* z (+ z 1)))) ; (z*(z+1) 2) -> (2*(2+1)) -> 6

(f f) ; Error: application: not a procedure;
      ; expected a procedure that can be applied to arguments
      ;  given: 2
      ;  arguments...:


;; Had to check http://www.billthelizard.com/2010/05/sicp-exercise-134-procedures-as.html
;;  for an explanation
;;
;; If we use the substitution model
;;   (f f)
;;   (f 2) (now g takes the value 2)
;;   (2 2) -> 2 is not a procedure, so the thing errors