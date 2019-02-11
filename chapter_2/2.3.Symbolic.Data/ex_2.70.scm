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


;; Problem

(define rock-freq
  '(
    (A 2) (NA 16) 
    (BOOM 1) (SHA  3)
    (GET  2) (YIP  9)
    (JOB  2) (WAH  1)))

(define rock-encoding (generate-huffman-tree rock-freq))

(decode
 (encode
  '(GET A JOB SHA NA NA NA NA NA NA NA NA)
  rock-encoding)
 rock-encoding)

(define lyrics
  '(GET A JOB
   SHA NA NA NA NA NA NA NA NA
   GET A JOB
   SHA NA NA NA NA NA NA NA NA
   WAH YIP YIP YIP YIP 
   YIP YIP YIP YIP YIP
   SHA BOOM)
)

(length lyrics)

(length (encode lyrics
  rock-encoding)); = 84 ✔ 


;; Fixed length code -- 8 symbols, need 3 bits to encode them, as 2^3 = 8
;; that would mean 108 bits for the fixed length encoding, as compared
;; to the 84 bits needed when using the Huffman encoding