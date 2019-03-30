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

(define (count-pairs x)
  ;; Keeping a list of traversed pairs
  (define visited (cons nil nil))

  (define (traverse elem)
    (display "traversing ") (display elem) (newline)
    (cond
      ((not (pair? elem)) 0)
      ((in-list visited elem) 0)
      (else
       (begin
         (display visited) (newline)
         (append! visited (cons elem nil))
         (+ (traverse (car elem))
            (traverse (cdr elem))
            1)))))

  (traverse x))

(count-pairs '(1 1 1 1 1 1)) ; ✔

(count-pairs (cons 'a nil)) ; ✔

(count-pairs '(1 2 3 4 5 6 7 8 9)) ; ✔

(count-pairs '((1 2 3) 4 5 6)) ; ✔

(define three-pair-list (cons 'a (cons 'b (cons 'c '()))))
three-pair-list
(count-pairs three-pair-list) ; ✔

(define a-pair (cons 'a nil))
(define b-pair (cons 'b nil))
(define three-pair-list-2 (cons a-pair b-pair))
(set-cdr! b-pair a-pair)

(count-pairs three-pair-list-2) ; ✔

(define x-pair (cons 'x nil))
(define y-pair (cons 'y nil))
(define three-pair-list-3 (cons y-pair y-pair))

(set-cdr! y-pair x-pair)
(set-car! y-pair x-pair)


(count-pairs three-pair-list-3) ; ✔

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define caused-loop (make-cycle three-pair-list))

(count-pairs caused-loop) ; ✔