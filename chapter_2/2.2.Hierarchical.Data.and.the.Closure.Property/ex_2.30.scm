#lang sicp

(define square
  (lambda (x) (* x x)))

(define (square-tree tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (square sub-tree)))
       tree))


(define t1 (list 1 
                  (list 2 (list 3 4) 5) 
                  (list 6 7)))

t1
(square-tree t1)