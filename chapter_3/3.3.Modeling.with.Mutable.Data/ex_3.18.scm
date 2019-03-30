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

(define (has-cycle? lst)
  (define visited (cons 'start-point nil))

  (define (traverse l)
    (display visited)(newline)
    (if (null? l)
        #f
        (let
            ((curr-node (car l))
             (rest-of-list (cdr l)))
          (if (in-list visited curr-node)
              #t
              (begin
                (append! visited (list curr-node))
                (traverse rest-of-list))))))

  (traverse lst))


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

(set-car! C-pair D-pair) ; just not to leave the D hangin ^_^
(set-cdr! C-pair B-pair)
(has-cycle? A-pair) ; ✔

  