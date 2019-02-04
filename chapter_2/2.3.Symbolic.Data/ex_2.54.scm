#lang sicp

(define (equal? lst1 lst2)
  (cond
    ((and (null? lst1) (null? lst2))
     #t)
    ((and (not (null? lst1)) (null? lst2))
     #f)
    ((and (null? lst1) (not (null? lst2)))
     #f)
    ((and (not (list? lst1)) (not (list? lst1)))
     (eq? lst1 lst2))
    ((and (not (list? lst1)) (list? lst1))
     #f)
    ((and (list? lst1) (not (list? lst1)))
     #f)
    ((and (list? lst1) (list? lst2))
     (and
      (equal? (car lst1) (car lst2))
      (equal? (cdr lst1) (cdr lst2))))
    ))

(equal? '(this is a list) 
        '(this is a list)) ; #t ✔

(equal? '(this is a list) 
        '(this (is a) list)) ; #f ✔

(equal? '(this (is a) list) 
        '(this (is a) list)) ; #t ✔

(equal? '(this (is a) list) 
        '(this (is a) list too)) ; #f ✔

(equal? '(this (is a) list (too)) 
        '(this (is a) list (too))) ; #t ✔

(equal? '(this (is a) list too) 
        '(this (is a) list (too))) ; #f ✔


(equal? '(this (is a) list) 
        '(this (is b) list)) ; #f ✔ 
