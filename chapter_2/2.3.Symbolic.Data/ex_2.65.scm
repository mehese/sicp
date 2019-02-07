#lang sicp

;; Imports

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (entry set)) true)
        ((< x (entry set))
         (element-of-set? 
          x 
          (left-branch set)))
        ((> x (entry set))
         (element-of-set? 
          x 
          (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry set)) set)
        ((< x (entry set))
         (make-tree 
          (entry set)
          (adjoin-set x (left-branch set))
          (right-branch set)))
        ((> x (entry set))
         (make-tree
          (entry set)
          (left-branch set)
          (adjoin-set x (right-branch set))))))

(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list 
         (left-branch tree)
         (cons (entry tree)
               (copy-to-list 
                (right-branch tree)
                result-list)))))
  (copy-to-list tree '()))

(define (list->tree elements)
  (car (partial-tree 
        elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size 
             (quotient (- n 1) 2)))
        (let ((left-result 
               (partial-tree 
                elts left-size)))
          (let ((left-tree 
                 (car left-result))
                (non-left-elts 
                 (cdr left-result))
                (right-size 
                 (- n (+ left-size 1))))
            (let ((this-entry 
                   (car non-left-elts))
                  (right-result 
                   (partial-tree 
                    (cdr non-left-elts)
                    right-size)))
              (let ((right-tree 
                     (car right-result))
                    (remaining-elts 
                     (cdr right-result)))
                (cons (make-tree this-entry 
                                 left-tree 
                                 right-tree)
                      remaining-elts))))))))

;; Problem

(define (union-set set1 set2)
  (define (union-lists l1 l2)
    (cond
      ((null? l1) l2)
      ((null? l2) l1)
      (else
       (let
           ((h1 (car l1))
            (h2 (car l2))
            (t1 (cdr l1))
            (t2 (cdr l2)))
         (cond
           ((= h1 h2) (cons h1 (union-lists t1 t2)))
           ((> h1 h2) (cons h2 (union-lists l1 t2)))
           ((< h1 h2) (cons h1 (union-lists t1 l2))))))))
  (list->tree
   (union-lists (tree->list set1) (tree->list set2))))

(define (intersection-set set1 set2)
  (define (intersection-lists l1 l2)
    (if (or (null? l1) (null? l2))
        '()
        (let
           ((h1 (car l1))
            (h2 (car l2))
            (t1 (cdr l1))
            (t2 (cdr l2)))
         (cond
           ((= h1 h2) (cons h1 (intersection-lists t1 t2)))
           ((> h1 h2) (intersection-lists l1 t2))
           ((< h1 h2) (intersection-lists t1 l2))))))
  (list->tree
   (intersection-lists (tree->list set1) (tree->list set2)))) 

(define set1
  (list->tree '(1 2 3 4 5 7)))

(define set2
  (list->tree '(3 4 5 6)))

(define set-odd
  (list->tree '(1 3 5 7 9)))

(define set-even
  (list->tree '(2 4 6 8)))

(tree->list (union-set set1 set2)); ✔ 
(tree->list (intersection-set set1 set2)); ✔ 
(tree->list (union-set set1 '())); ✔ 
(tree->list (intersection-set set1 '())); ✔ 
(tree->list (intersection-set '() set1)); ✔ 
(tree->list (union-set set-odd set-even)); ✔ 
(tree->list (intersection-set set-odd set-even)); ✔ 



