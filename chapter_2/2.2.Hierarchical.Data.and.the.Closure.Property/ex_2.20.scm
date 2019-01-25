#lang sicp

(define (even? n)
  (= 0 (remainder n 2)))

(define (same-parity x . lst)
  
  (define (same-parity? n)
    (= (remainder x 2) (remainder n 2)))
  
  (define (concat-matching sublist)
    (cond
      ((null? sublist) nil)
      ((same-parity? (car sublist)) (cons (car sublist) (concat-matching (cdr sublist))))
      (else (concat-matching (cdr sublist)))))
  
  (cons x (concat-matching lst)))


(same-parity 1 2 3 4 5 6 7)

(same-parity 2 3 4 5 6 7)
