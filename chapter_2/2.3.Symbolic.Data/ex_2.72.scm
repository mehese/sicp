#lang sicp

;; Prerequisites

(define (make-leaf symbol weight) (list 'leaf symbol weight))
(define (leaf? object) (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left right(append (symbols left) (symbols right)) (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree) (list (symbol-leaf tree)) (caddr tree)))

(define (weight tree)
  (if (leaf? tree) (weight-leaf tree) (cadddr tree)))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: 
               CHOOSE-BRANCH" bit))))

;; Procedure

;; m - message length
;; N - alphabet length

(define (is-in elem set)
  ;; O(N) per each search
  (cond
    ((null? set) #f)
    ((eq? (car set) elem) #t)
    (else
     (is-in elem (cdr set)))))
     
(define (encode-symbol lett tree)
  ;; Will N calls to is-in for 2.71 like problems
  ;;  => O(N^2)
  (define (build-lst subtree code)
    (cond
      ((and (leaf? subtree) (symbol-leaf subtree))
       code)
      (else
       (let
           ((symbols-left (symbols (left-branch subtree))))
         (if (is-in lett symbols-left)
             (build-lst (left-branch subtree) (append code (list 0)))
             (build-lst (right-branch subtree) (append code (list 1))))))))
  (build-lst tree '()))

(define (encode message tree)
  ;; m calls to encode-symbol
  ;; also append might be O(m), but let's consider it O(1) to save us issues
  ;; about the implementation details
  (if (null? message)
      '()
      (append 
       (encode-symbol (car message) 
                      tree)
       (encode (cdr message) tree))))

;; O(m*N^2) to encode length m messages for an N sized alphabet for trees like the one in 2.71.
;;  For the most frequent symbol the order is O(1) as it's a leaf, and thankfully the routine
;;  checks the left branch first and saves us an O(N) lookup that would return false.

;; As the 2.71 tree is the most imbalanced huffman tree there is, we can assume any more balanced
;;  tree will have a shorter time complexity, as the O(N) traversal would transform to an O(logN)
;;  one for more balanced trees. With lookup still O(N) the average time complexity would be
;;  O(m*logN*N) but the worst case one would still be O(m*N^2).