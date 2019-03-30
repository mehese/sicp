#lang sicp

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (append! x y)
  (if (null? x)
      (set! x y)
      (set-cdr! (last-pair x) y))
  x)

(define (in-list lst elem)
  (cond
    ((null? lst) #f)
    ((eq? (car lst) elem) #t)
    (else (in-list (cdr lst) elem))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

;; (This requires a very clever idea.)
;;  Well, I had the very clever idea of googling "common programming
;;   interview questions" a while back, and I still remember the answer
;;   to finding a cycle in a linked list with O(1) memory space
(define (has-cycle? lst)

  (define (two-speed-traversal tortoise hare)
    (cond
      ((null? hare) #f)
      ((null? (cdr hare)) #f)
      ((eq? (car tortoise) (car hare)) #t)
      (else
       (two-speed-traversal (cdr tortoise) (cddr hare)))))

  (two-speed-traversal lst (cdr lst)))

;; Expecting #f
(has-cycle? '(a b c d)) ; ✔
(has-cycle? '((a b c) (a b c))) ; ✔
(has-cycle? '((a b c) a b c)) ; ✔
(has-cycle? '((1) (1 2) (1 2 3))) ; ✔

;; Expecting #t
(has-cycle? (make-cycle '(a b c d e))) ; ✔
(has-cycle? (make-cycle '(a))) ; ✔
(has-cycle? (make-cycle '(1 1 1 1 1 1))) ; ✔

(define d-pair (cons 'd nil))
(define c-pair (cons 'c d-pair))
(define b-pair (cons 'b c-pair))
(define a-pair (cons 'a b-pair))

(set-cdr! d-pair b-pair)

(has-cycle? a-pair) ; ✔

(define D-pair (cons 'D nil))
(define C-pair (cons 'C D-pair))
(define B-pair (cons 'B C-pair))
(define A-pair (cons 'A B-pair))

(set-car! C-pair D-pair)
(set-cdr! C-pair B-pair)
(has-cycle? A-pair) ; ✔