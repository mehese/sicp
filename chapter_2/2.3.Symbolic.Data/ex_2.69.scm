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

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) 
         (cons x set))
        (else 
         (cons (car set)
               (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set 
         (make-leaf (car pair)    ; symbol
                    (cadr pair))  ; frequency
         (make-leaf-set (cdr pairs))))))

;; Problem

(define (successive-merge leaf-set)
  ;; successively merge the smallest-weight elements of the set until there is only
  ;; one element left, which is the desired Huffman tree
 (if (= 1 (length leaf-set))
     leaf-set
     (let
         ((first (car leaf-set))
          (second (cadr leaf-set))
          (rest-of-set (cddr leaf-set)))
       (successive-merge
        (insert-in-order
         (make-code-tree first second)
         rest-of-set)))))
          
(define (insert-in-order elem lst)
  (cond
    ((null? lst) (list elem))
    ((<= (weight elem) (weight (car lst)))
     (cons elem lst))
    (else
     (cons (car lst) (insert-in-order elem (cdr lst))))))


(define (generate-huffman-tree pairs)
  (successive-merge 
   (make-leaf-set pairs)))

(define sample-tree
  (make-code-tree 
   (make-leaf 'A 4)
   (make-code-tree
    (make-leaf 'B 2)
    (make-code-tree 
     (make-leaf 'D 1)
     (make-leaf 'C 1)))))

(define all-lets (list
 '(E 21912) '(T 16587) '(A 14810) '(O 14003) '(I 13318) '(N 12666) '(S 11450)
 '(R 10977) '(H 10795) '(D 7874) '(L 7253) '(U 5246) '(C 4943) '(M 4761)
 '(F 4200) '(Y 3853) '(W 3819) '(G 3693) '(P 3316) '(B 2715) '(V 2019) '(K 1257)
 '(X 315) '(Q 205) '(J 188) '(Z 128)))

(define enc (generate-huffman-tree all-lets))

(decode
 (encode
  '(H I T H E R E)
  enc)
 enc); ✔

(decode
 (encode
  '(T H E Q U I C K B R O W N F O X J U M P S O V E R T H E L A Z Y D O G)
  enc)
 enc); ✔ 
