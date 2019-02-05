#lang sicp

;; Imports
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) 
         '())
        ((element-of-set? (car set1) set2)
         (cons (car set1)
               (intersection-set (cdr set1) 
                                 set2)))
        (else (intersection-set (cdr set1) 
                                set2))))

(element-of-set? 'a '(b a c))

(adjoin-set 'b '(a c d))

(intersection-set '(b a c) '(c b d))

(define (union-set set1 set2)
  (cond
    ((null? set1) set2)
    ((null? set2) set1)
    ((element-of-set? (car set1) set2)
     (union-set (cdr set1) set2))
    (else
     (union-set (cdr set1) (adjoin-set (car set1) set2)))))

(union-set '(b a c) '(c b d)) ; ✔ 
(union-set '() '(a)) ; ✔
(union-set '(a b c) '(a b c)) ; ✔ 
(union-set '(a b c) '(a)) ; ✔ 
(union-set '(a b c) '(1 2 3)) ; ✔ 
