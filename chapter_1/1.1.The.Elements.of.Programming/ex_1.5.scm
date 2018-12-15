#lang sicp

(define (p) (p))

(define (test x y)
  (if (= x 0) 0 y))

(test 0 (p))

;;; calling (p) -> ∞ loop
;;; normal order evaluation -- the program freezes since (p) is evaluated before
;;;     being passed to the test procedure
;;; applicative order evaluation
;;;     the program wuld return 0, as in this case evaluating (p) is not necessary