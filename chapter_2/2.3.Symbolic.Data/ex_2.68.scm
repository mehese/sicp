#lang sicp

;; Imports

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) 
                (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch 
                (car bits) 
                current-branch)))
          (if (leaf? next-branch)
              (cons 
               (symbol-leaf next-branch)
               (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) 
                        next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: 
               CHOOSE-BRANCH" bit))))

;; Problem


(define (is-in elem set)
  (cond
    ((null? set) #f)
    ((eq? (car set) elem) #t)
    (else
     (is-in elem (cdr set)))))
     
(define (encode-symbol lett tree)
  (define (build-lst subtree code)
    (cond
      ;; we arrived at the correct leaf
      ((and (leaf? subtree) (symbol-leaf subtree))
       code)
      ;; somewhere along the road we got lost
      ((and (leaf? subtree) (not (symbol-leaf subtree)))
       (error "Whoa, leaf symbol =/= the symbol provided"))
      ;;
      (else
       (let
           ((symbols-left (symbols (left-branch subtree))))
         (if (is-in lett symbols-left)
             (build-lst (left-branch subtree) (append code (list 0)))
             (build-lst (right-branch subtree) (append code (list 1))))))))
  (build-lst tree '()))

(define (encode message tree)
  (if (null? message)
      '()
      (append 
       (encode-symbol (car message) 
                      tree)
       (encode (cdr message) tree))))

(define sample-tree
  (make-code-tree 
   (make-leaf 'A 4)
   (make-code-tree
    (make-leaf 'B 2)
    (make-code-tree 
     (make-leaf 'D 1)
     (make-leaf 'C 1)))))

(define sample-message 
  '(0 1 1 0 0 1 0 1 0 1 1 1 0))
;; {A D A B B C A}

(define adabbca '(A D A B B C A))
(encode adabbca sample-tree); ✔ 
(decode sample-message sample-tree)
(decode
 (encode
  '(B A A B A A C)
  sample-tree)
 sample-tree); ✔ 

(decode
 (encode
  '(C A B D A C)
  sample-tree)
 sample-tree); ✔ 

(decode
 (encode
  '(C)
  sample-tree)
 sample-tree); ✔ 

(decode
 (encode
  '(D D D)
  sample-tree)
 sample-tree); ✔ 

(decode
 (encode
  '(D A A A A A)
  sample-tree)
 sample-tree); ✔ 
