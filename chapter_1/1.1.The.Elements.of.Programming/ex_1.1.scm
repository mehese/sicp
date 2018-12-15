#lang sicp
10 ; 10
(+ 5 3 4) ; 12
(- 9 1) ; 8
(/ 6 2) ; 3
(+ (* 2 4) (- 4 6)) ; 6
(define a 3) ; *bump*, a = 3
(define b (+ a 1)) ; *bump*, b = 4
(+ a b (* a b)) ; 3 + 4 + (3*4) = 7+12 = 19
(= a b) ; #f
(if (and (> b a) (< b (* a b))) ; (4 > 3) and (4 < 3*4) -> #t
    b 
    a); 4

(cond ((= a 4) 6) ; *bump* #f
      ((= b 4) (+ 6 7 a)) ; 16
      (else 25)) ; *bump*

(+ 2 (if (> b a) b a)) ; 6, b > a -> b=4 + 2 = 6

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1)) ; 16, a<b -> b=4, 4*(3+1)