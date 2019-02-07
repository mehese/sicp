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

;; Problem

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append                 ;; this effectively returns an *ordered list* as
       (tree->list-1          ;; it reuturns a list of the elements on the left side
        (left-branch tree))   ;; which are all smaller than the entry which is smaller
       (cons (entry tree)     ;; than all the elements on the right side. Something tells
             (tree->list-1    ;; me we're gonna be introducing merge-sort and quick-sort soon
              (right-branch tree))))))

(define (tree->list-2 tree)
  ;; This version basically does the same thing as the above, with the exeption of accumulating
  ;;  the results to a single list while depopulating the tree
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

(define (set-to-tree lst)
  (define (load lst tree)
    (if (null? lst)
        tree
        (load (cdr lst) (adjoin-set (car lst) tree))))
  (load (cdr lst) (make-tree (car lst) '() '())))

;; Figure 2.16
(display "Example tree 1: ")
(define tree-2-16-1 (set-to-tree '(7 3 9 1 5 11)))
(display tree-2-16-1) (newline)
(display "method 1: ") (display (tree->list-1 tree-2-16-1)) (newline)
(display "method 2: ") (display (tree->list-2 tree-2-16-1))
(newline)
(display "Example tree 2: ")
(define tree-2-16-2 (set-to-tree '(3 1 7 5 9 11)))
(display tree-2-16-2) (newline)
(display "method 1: ") (display (tree->list-1 tree-2-16-2)) (newline)
(display "method 2: ") (display (tree->list-2 tree-2-16-2))
(newline)
(display "Example tree 3: ")
(define tree-2-16-3 (set-to-tree '(5 3 9 1 7 11)))
(display tree-2-16-3) (newline)
(display "method 1: ") (display (tree->list-1 tree-2-16-3)) (newline)
(display "method 2: ") (display (tree->list-2 tree-2-16-3))
(newline)
;; All return the same list
(newline)

;; Tree in figure 2.17 
(define funky-tree (set-to-tree '(1 2 3 4 5 6 7)))
(display "Degenerate tree: ") (display funky-tree) (newline)
(display "method 1: ") (display (tree->list-1 funky-tree)) (newline)
(display "method 2: ") (display (tree->list-2 funky-tree))
(newline)

;; Again, results are always the same, as both procedures return ordered lists
;;  and traverse the lists in order

;; 2

;; The key is to note the problem asks for the order of growth for a *balanced*
;;  binary tree.
;;
;; Procedure 1 is clearly NlogN. Appending a list to another is an O(N) operation
;;  that we do at each depth, and the depth of a balanced binary tree is logN.
;;
;; Procedure 2 uses cons, which unlike append is O(1)
;;  Some people people at this link disagree http://community.schemewiki.org/?sicp-ex-2.63
;;  If cons is O(1), cons is applied once for each number in the list, so the procedure
;;  would be O(N)
