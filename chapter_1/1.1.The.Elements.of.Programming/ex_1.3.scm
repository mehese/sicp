#lang sicp

(define (max x y)
  (if (> x y) x y))

(define (sum-of-squares x y)
  (+ (* x x) (* y y)))

(define (custom-fun x y z)
  (sum-of-squares
   (max x y)
   (max y z)))

;;; a few tests
(= 41 (custom-fun 5 3 4)) ; 5*5 + 4*4 = 25 + 16 = 41
(= 8 (custom-fun 2 2 2)) ; 2^2 + 2^2 = 8
(= 18 (custom-fun 2 3 3)) ; 3^2 + 3^2 = 18
(= 50 (custom-fun 5 5 4)) ; 5^2 + 5^2 = 50