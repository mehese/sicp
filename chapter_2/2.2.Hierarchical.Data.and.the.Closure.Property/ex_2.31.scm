#lang sicp

(define (square x)
  (* x x))

(define (tree-map fun tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (tree-map fun sub-tree)
             (fun sub-tree)))
       tree))

(define (square-tree tree) 
  (tree-map square tree))

(define l (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(square-tree l)