#lang sicp

;; naive implementation
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))


;; tail recursive implementation
(define (factorial-tr n)
  (define (factorial-iter counter acc)
    (if (= counter n)
        (* counter acc)
        (factorial-iter (+ counter 1) (* acc counter))))
  (factorial-iter 1 1))


(define lst '(1 2 3 4 5 6 7 8 9 10))

(map factorial lst)
(map factorial-tr lst)