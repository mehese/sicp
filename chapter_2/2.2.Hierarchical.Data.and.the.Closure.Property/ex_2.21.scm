#lang sicp

(define square
  (lambda (x) (* x x)))

(define (square-list-1 items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list-1 (cdr items)))))

(define (square-list items)
  (map square items))

(square-list-1 (list 1 2 3 4))
(square-list (list 1 2 3 4))
