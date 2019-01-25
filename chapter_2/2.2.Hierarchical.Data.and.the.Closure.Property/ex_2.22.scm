#lang sicp

(define (square n)
  (* n n))

(define (square-list-a items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))

(define (square-list-b items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square 
                     (car things))))))
  (iter items nil))


;; Reverses list because current item is always consed after
;;  operations on the end of the list
(square-list-a (list 1 2 3 4))

;; As seen in ex 2.18
;; Notice that the two operations below are not commutative
;;  (cons elem list) -> list
;;  (cons list elem) -> pair with list and elem
;;
;; so swapping a list and an elem in a cons gives bad results.
;;  Also bear in mind that a list (a b c d) is defined as
;;   (cons a (cons b (cons c (cons 4 nil))))
(square-list-b (list 1 2 3 4))