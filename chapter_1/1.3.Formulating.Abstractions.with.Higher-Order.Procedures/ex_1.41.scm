#lang sicp

(define (double f)
  (lambda (x) (f (f x))))

((double inc) 0)
((double inc) 1)

(((double (double double)) inc) 5) ; res: 21
