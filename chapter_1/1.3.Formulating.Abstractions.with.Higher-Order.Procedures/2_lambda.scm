#lang sicp

(define square (lambda (x) (* x x))) ; ^_^

(map (lambda (x) (+ x 4)) '(1 2 3 4 5 6))

(map (lambda (x) (/ 1 (* x (+ x 2)))) '(1 2 3 4 5 6))

((lambda (x y z) (+ x y (square z))) 1 2 3)

(define (f x y)
  (let ((a (+ 1 (* x y)))
        (b (- 1 y)))
    (+ (* x (square a))
       (* y b)
       (* a b))))


;; a and b are local to the scope of let
(let ((a 5)(b 3)) (+ 2 a b))