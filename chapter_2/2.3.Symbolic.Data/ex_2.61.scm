#lang sicp

;; Imports
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

;; Implementation

(define (adjoin-set x set)
  (cond
    ((null? set) (list x))
    ((= (car set) x) set)    
    ((> (car set) x) (cons x set))
    (else
     (cons (car set) (adjoin-set x (cdr set)))
     )))

(adjoin-set 1 '()) ; ✔
(adjoin-set 1 '(1 2 3 4)) ; ✔
(adjoin-set 1 '(2 3 4)) ; ✔
(adjoin-set 9 '(1 2 3)) ; ✔
(adjoin-set 4 '(1 2 3 5 6)) ; ✔

