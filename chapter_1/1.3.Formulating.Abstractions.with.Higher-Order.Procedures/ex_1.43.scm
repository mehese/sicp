#lang sicp

(define square (lambda (x) (* x x)))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (define (iter acc i)
    (if (= i n)
        acc
        (iter (compose f acc) (+ i 1))))
  (iter f 1))

((repeated inc 3) 2) ; 2 + 3 = 5
((repeated inc 6) 0) ; 0 + 6 = 6
((repeated square 2) 5) ; = 625 ✔
