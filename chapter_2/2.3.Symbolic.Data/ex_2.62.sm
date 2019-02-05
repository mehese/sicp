#lang sicp

;; Imports
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (cond
    ((null? set) (list x))
    ((= (car set) x) set)    
    ((> (car set) x) (cons x set))
    (else (cons (car set) (adjoin-set x (cdr set))))))


;; Implementation

(define (union-set set1 set2)
  (cond
    ((null? set1) set2)
    ((null? set2) set1)
    (else
     (let
         ((h1 (car set1))
          (h2 (car set2))
          (t1 (cdr set1))
          (t2 (cdr set2)))
       (cond
         ((= h1 h2) (cons h1 (union-set t1 t2)))
         ((< h1 h2) (cons h1 (union-set t1 set2)))
         ((> h1 h2) (cons h2 (union-set set1 t2))))))))

(union-set '(1 2 3) '()) ; ✔
(union-set '() '(1 2 3)) ; ✔
(union-set '(1 3 4 5) '(2 4 6 8 9)) ; ✔
(union-set '(1 2 3) '(4 5 6)) ; ✔
(union-set '(4 5 6) '(1 2 3)) ; ✔
(union-set '(1 2 3) '(1 2 3)) ; ✔
(union-set '(1 3 5) '(2 4 6)) ; ✔