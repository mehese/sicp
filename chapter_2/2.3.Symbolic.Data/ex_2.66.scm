#lang sicp

;; Imports

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right) (list entry left right))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let
              ((left-tree (car left-result))
               (non-left-elts (cdr left-result))
               (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts) right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree) remaining-elts))))))))

;; Problem

(define (make-record key name)
  (cons key name))

(define (key record)
  (car record))

(define (value record)
  (cdr record))


(define (lookup given-key set)
  (cond ((null? set) false)
        ((= given-key (key (entry set))) (entry set))
        ((< given-key (key (entry set))) (lookup given-key (left-branch set)))
        ((> given-key (key (entry set))) (lookup given-key (right-branch set)))))

(define l1 (list->tree
            (list
             (make-record 1 "Alice")
             (make-record 2 "Bob")
             (make-record 3 "Charlotte")
             (make-record 4 "Dave")
             (make-record 5 "Eliza")
             (make-record 6 "Frank")
             (make-record 7 "George")             
             )))

(lookup 1 l1); ✔ 
(lookup 2 l1); ✔
(lookup 3 l1); ✔
(lookup 4 l1); ✔
(lookup 5 l1); ✔
(lookup 6 l1); ✔
(lookup 7 l1); ✔ 
(lookup 0 l1); ✔ 
(lookup 8 l1); ✔ 

