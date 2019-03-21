#lang sicp

(define (make-accumulator acc)
  (lambda (amount)
    (begin
      (set! acc (+ amount acc))
      acc)))

(define A (make-accumulator 5))

(A 10) ; ✔

(A 10) ; ✔