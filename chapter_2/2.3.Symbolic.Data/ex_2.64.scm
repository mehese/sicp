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

(define (set-to-tree lst)
  (define (load lst tree)
    (if (null? lst)
        tree
        (load (cdr lst) (adjoin-set (car lst) tree))))
  (load (cdr lst) (make-tree (car lst) '() '())))

;; Problem

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

;; The partial tree takes the first n elements of the list it is provided
;;  and returns a list that contains a balanced tree of the first n elements
;;  in its first position and the rest of the elements as a list. When given
;;  n = size of the list, it produces the full balanced binary tree.

;; At first it recursively applies itself on the left size, halfing the size of the
;; subtree it generates at each size. The left subtree of the final tree the procedure
;; generates is going to be the tree the recursive calls return. The center of the tree
;; will be the first element not packed in the tree (remember the list is sorted). Then
;; the right side of the tree will be created by clustering up the next n/2 elements of the
;; result of the first recursive call in a list. Finally return the
;; { {left-tree}-(midpoint)-{right-tree} rest of elements } list
;;
;; Note the procedure returns junk when passed an n > (/ (length elts) 2)

(list->tree '(1 3 5 7 9 11))
;; result is:
;;
;;          5
;;    .-----------.
;;    |           |
;;    1           9
;;    --.       .---.
;;      |       |   |
;;      3       7  11

;; Running time O(N). the number of halfings needed increases with log(N), but each time
;;  the procedure makes 2 calls. The final cons is O(1) So we have 2^log(N) calls -> O(N).
;;  Alternatively, one may notice that a cons operation is made for each element of the list,
;;  there's a total of N elements, so again this leads us to the O(N) result.

(list->tree '(1 2 3))

(list->tree '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20))
