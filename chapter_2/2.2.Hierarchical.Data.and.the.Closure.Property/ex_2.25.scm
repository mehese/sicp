#lang sicp

(define l1 (list 1 3 (list 5 7) 9))
(car (cdr (car (cdr (cdr l1)))))
(newline)
(define l2 (list (list 7)))
(car (car l2))
(newline)
(define l3 (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 (cons 6  7)))))))
(cdr (cdr (cdr (cdr (cdr (cdr l3))))))
(newline)
