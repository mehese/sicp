#lang sicp

(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

(define (double n)
  (+ n n))

(define (even? n)
  (= (remainder n 2) 0))

(define (halve n)
  (/ n 2)) ; only use for even n

(define (mul a b)
  (cond
    ((= b 0) 0)
    ((even? b) (mul (double a) (halve b)))
    (else (+ a (mul a (- b 1))))))

(list
 (list (* 2 4) (mul 2 4))
 (list (* 3 4) (mul 3 4))
 (list (* 3 3) (mul 3 3))
 (list (* 1 0) (mul 1 0))
 (list (* 1 1) (mul 1 1))
 (list (* 5 5) (mul 5 5)))