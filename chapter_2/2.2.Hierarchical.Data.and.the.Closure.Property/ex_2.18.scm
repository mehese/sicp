#lang sicp

;; Notice that the two operations below are not commutative
;;  (cons elem list) -> list
;;  (cons list elem) -> pair with list and elem
(cons 99 (list 1 2 3))
(cons (list 1 2 3) 99)

(define (last-pair lst)
  (if (null? (cdr lst))
      lst
      (last-pair (cdr lst))))

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) 
            (append (cdr list1) 
                    list2))))

(define (reverse lst)
  (if (null? (cdr lst))
      (last-pair lst)
      (append (reverse (cdr lst)) (cons (car lst) nil))))




(reverse (list 1 2 3 4))
(reverse (list "a" "l" "u" "p" "i" "g" "u" "s"))