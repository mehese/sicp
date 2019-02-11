#lang sicp

;; Imports

(define (make-leaf symbol weight) (list 'leaf symbol weight))
(define (leaf? object) (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right)) (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree) (list (symbol-leaf tree)) (caddr tree)))

(define (weight tree)
  (if (leaf? tree) (weight-leaf tree) (cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch) (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: 
               CHOOSE-BRANCH" bit))))

(define (is-in elem set)
  (cond
    ((null? set) #f)
    ((eq? (car set) elem) #t)
    (else (is-in elem (cdr set)))))
     
(define (encode-symbol lett tree)
  (define (build-lst subtree code)
    (cond
      ((and (leaf? subtree) (symbol-leaf subtree))
       code)
      ((and (leaf? subtree) (not (symbol-leaf subtree)))
       (error "Whoa, leaf symbol =/= the symbol provided"))
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
       (encode-symbol (car message) tree)
       (encode (cdr message) tree))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else 
         (cons (car set) (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set 
         (make-leaf (car pair)    ; symbol
                    (cadr pair))  ; frequency
         (make-leaf-set (cdr pairs))))))

(define (successive-merge leaf-set)
 (if (= 1 (length leaf-set))
     (car leaf-set)
     (let
         ((first (car leaf-set))
          (second (cadr leaf-set))
          (rest-of-set (cddr leaf-set)))
       (successive-merge
        (insert-in-order (make-code-tree first second) rest-of-set)))))

(define (insert-in-order elem lst)
  (cond
    ((null? lst) (list elem))
    ((<= (weight elem) (weight (car lst))) (cons elem lst))
    (else (cons (car lst) (insert-in-order elem (cdr lst))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define up-to-5
  '(
    (1  1)
    (2  2)
    (3  4)
    (4  8)
    (5 16)
    ))

(define huf-5 (generate-huffman-tree up-to-5))

huf-5

;;            1
;; (5, 2^4) <---+{1 2 3 4 5} 31
;;                    +
;;                    | 0
;;            1       v
;; (4, 2^3) <---+ {1 2 3 4} 15
;;                    +
;;                    | 0
;;            1       v
;; (3, 2^2) <---+  {1 2 3} 7
;;                    +
;;                    | 0
;;            1       v
;; (2, 2)   <---+   {1 2} 3
;;                    +
;;                    | 0
;;                    v
;;                 (1, 2^0)

(encode '(1) huf-5)
(encode '(5) huf-5)


(define up-to-10
  '(
    (1  1)
    (2  2)
    (3  4)
    (4  8)
    (5 16)
    (6 32)
    (7 64)
    (8 128)
    (9 256)
    (10 512)
    ))

(define huf-10 (generate-huffman-tree up-to-10))

huf-10

;;             1
;; (10, 2^9) <---+ {1 2 3 4 5 6 7 8 9 10} 1023
;;                             +
;;                             |0
;;             1               v
;;  (9, 2^8) <---+ {1 2 3 4 5 6 7 8 9 10} 511
;;                             +
;;                             |
;;                             |0
;;                             |
;;                             .
;;                             .
;;                             .
;;                             .
;;                             |
;;                     1       v
;;          (5, 2^4) <---+{1 2 3 4 5} 31
;;                             +
;;                             | 0
;;                     1       v
;;          (4, 2^3) <---+ {1 2 3 4} 15
;;                             +
;;                             | 0
;;                     1       v
;;          (3, 2^2) <---+  {1 2 3} 7
;;                             +
;;                             | 0
;;                     1       v
;;          (2, 2)   <---+   {1 2} 3
;;                             +
;;                             | 0
;;                             v
;;                          (1, 2^0)



(encode '(1) huf-10)
(encode '(10) huf-10)

;; For such trees only one bit is required to code the most
;;  frequent symbol. We will always need n-1 bits to encode the least frequent one.
;;  The reason for this is that the aggregate weight of the least frequent n-1 elements
;;  is always smaller than the weight of the nth element, so at each level of depth of the
;;  tree we will have exactly one leaf -- except for the bottom level, where we will have two.