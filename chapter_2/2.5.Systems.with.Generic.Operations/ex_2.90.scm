#lang sicp

;; Racket hash table
(#%require (only racket/base make-hash))
(#%require (only racket/base hash-set!))
(#%require (only racket/base hash-ref))
(define *op-table* (make-hash))
(define (put op type proc) (hash-set! *op-table* (list op type) proc))
(define (get op type) (hash-ref *op-table* (list op type) #f)) ;; '() evaluates as #t o_O

;; Coercions table
(define *coercion-table* (make-hash))
(define (put-coercion type1 type2 type1->type2)
  (hash-set! *coercion-table* (list type1 type2) type1->type2))
(define (get-coercion type1 type2)
  (hash-ref *coercion-table* (list type1 type2) #f))

;; Same as in previous excercises
(define (attach-tag type-tag contents)
  (cond
    ((pair? contents) (cons type-tag contents))
    ((number? contents) contents)
    (else (error "What are you trying to tag here? Ain't a pair and ain't a number"))))

(define (type-tag datum)
  (cond
    ((pair? datum) (car datum))
    ((number? datum) 'scheme-number)
    (else (error "Bad tagged datum: TYPE-TAG" datum))))

(define (contents datum)
  (cond
    ((pair? datum) (cdr datum))
    ((number? datum) datum)
    (else (error "Bad tagged datum: CONTENTS" datum))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2 (apply-generic op (t1->t2 a1) a2))
                        (t2->t1 (apply-generic op a1 (t2->t1 a2)))
                        (else (error "No method for these types" (list op type-tags))))))
              (error "No method for these types" (list op type-tags)))))))

(define (install-number-operation-aliases)
  (put 'add '(scheme-number scheme-number) +)
  (put 'sub '(scheme-number scheme-number) -)
  (put 'mul '(scheme-number scheme-number) *)
  (put 'div '(scheme-number scheme-number) /)
  (put 'neg '(scheme-number) (lambda (x) (- x)))
  (put '=zero? '(scheme-number) (lambda (x) (= x 0)))

  'done-installing-scheme-operation-aliases)
(install-number-operation-aliases)

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (=zero? x) (apply-generic '=zero? x))
(define (neg x) (apply-generic 'neg x))

(define (all lst)
  (if (null? lst)
      #t
      (and (car lst) (all (cdr lst)))))


;; Implementation

(define (install-dense-term-list-package)
  ;; Not happy with all these repeating definitions
  (define (make-term order coeff) (list order coeff))
  (define (coeff term) (cadr term))
  (define (order term) (car term))

  (define (make-dense-term-list lst)
    lst)

  (define (adjoin-term term term-list)
    (if (= (order term) (length term-list))
        (cons (coeff term) term-list)
        (adjoin-term term
                     (adjoin-term
                      (make-term (length term-list) 0)
                      term-list))))

  (define (first-t term-list)
    (make-term (dec (length term-list)) (car term-list)))

  (define (rest-t term-list)
    (cdr term-list))

  (define (empty? term-list)
    (null? term-list))

  ;; interface to rest of the system
  (define (tag p)
    (if (null? p)
        (cons 'term-list-dense nil)
        (attach-tag 'term-list-dense p)))
  (put 'make 'term-list-dense
       (lambda (lst) (tag (make-dense-term-list lst))))
  (put 'adjoin-term 'term-list-dense
       (lambda (term term-list) (tag (adjoin-term term term-list))))
  (put 'first-term '(term-list-dense)
       (lambda (term-lst) (first-t term-lst)))
  (put 'rest-terms '(term-list-dense)
       (lambda (term-lst) (tag (rest-t term-lst))))
  (put 'empty-termlist? '(term-list-dense)
       (lambda (term-lst) (empty? term-lst)))
  'done-installing-dense-term-list-package)


(define (install-sparse-term-list-package)
  ;; Not happy with all these repeating definitions
  (define (make-term order coeff) (list order coeff))
  (define (coeff term) (cadr term))
  (define (order term) (car term))

  (define (make-sparse-term-list lst)
    lst)
  
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))

  (define (first-t term-list)
    (car term-list))
  
  (define (rest-t term-list)
    (cdr term-list))

  (define (empty? term-list)
    (null? term-list))

  ;; interface to rest of the system
  (define (tag p)
    (if (null? p)
        (cons 'term-list-sparse nil)
        (attach-tag 'term-list-sparse p)))
  (put 'make 'term-list-sparse
       (lambda (lst) (tag (make-sparse-term-list lst))))
  (put 'adjoin-term 'term-list-sparse
       (lambda (term term-list) (tag (adjoin-term term term-list))))
  (put 'first-term '(term-list-sparse)
       (lambda (term-lst) (first-t term-lst)))
  (put 'rest-terms '(term-list-sparse)
       (lambda (term-lst) (tag (rest-t term-lst))))
  (put 'empty-termlist? '(term-list-sparse)
       (lambda (term-lst) (empty? term-lst)))  
  'done-installing-sparse-term-list-package)

(install-dense-term-list-package)
(install-sparse-term-list-package)


(define (make-term-list-dense lst) ((get 'make 'term-list-dense) lst))
(define (make-term-list-sparse lst) ((get 'make 'term-list-sparse) lst))

;; Package installation implementation
(define (install-polynomial-package)

  (define (make-poly variable term-list)
    (cons variable term-list))

  (define (make-poly-from-dense variable term-list)
    (cons variable
          (make-term-list-dense term-list)))

  (define (make-poly-from-sparse variable term-list)
    (cons variable
          (make-term-list-sparse term-list)))
  
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2)(eq? v1 v2)))

  (define (all-terms terms)
    (if (empty-termlist? terms)
        '()
        (cons (first-term terms) (all-terms (rest-terms terms)))))
  
  (define (is-zero? p)
    (all (map (lambda (term) (=zero? (coeff term))) (all-terms (term-list p)))))

  ;; This is a bit hacked, but the alternative would be to declare a term type, which would
  ;;  increase the line count quite a bit
  (define (adjoin-term term term-list)
    ((get 'adjoin-term (type-tag term-list)) term (contents term-list)))
  (define (first-term term-list)
    (apply-generic 'first-term term-list))
  (define (rest-terms term-list)
    (apply-generic 'rest-terms term-list))
  (define (empty-termlist? term-list)
    (apply-generic 'empty-termlist? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))
  
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly 
         (variable p1)
         (add-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: ADD-POLY" (list p1 p2))))
  
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1))
                 (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term t1
                                 (add-terms (rest-terms L1) L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term t2
                                 (add-terms L1 (rest-terms L2))))
                   (else
                    (adjoin-term (make-term (order t1)
                                            (add (coeff t1) 
                                                 (coeff t2)))
                                 (add-terms (rest-terms L1)
                                            (rest-terms L2)))))))))

  (define (neg-terms term-list)
    (if (empty-termlist? term-list)
        term-list ;; Need to have a typed empty list
        (let
            ((this-term (first-term term-list)))
          (adjoin-term
           (make-term (order this-term)
                      (neg (coeff this-term)))
           (neg-terms (rest-terms term-list))))))
  
  (define (neg-poly p)
    (make-poly (variable p)
               (neg-terms (term-list p))))

  (define (sub-poly p1 p2)
    (add-poly p1 (neg-poly p2)))

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly 
         (variable p1)
         (mul-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: MUL-POLY" (list p1 p2))))

  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        L1 ;; Need to have a typed empty list
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        L ;; Need to have a typed empty list
        (let ((t2 (first-term L)))
          (adjoin-term (make-term (+ (order t1) (order t2))
                                  (mul (coeff t1) (coeff t2)))
                       (mul-term-by-all-terms t1 (rest-terms L))))))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'neg '(polynomial)
       (lambda (p1) (tag (neg-poly p1))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put '=zero? '(polynomial) is-zero?)

  (put 'tlist '(polynomial) (lambda (p) (term-list p)))
  (put 'make-dense 'polynomial
       (lambda (var terms) (tag (make-poly-from-dense var terms))))
  (put 'make-sparse 'polynomial
       (lambda (var terms) (tag (make-poly-from-sparse var terms))))

  'done-installing-polynomial-package)

(define (make-polynomial-from-dense var terms)
  ((get 'make-dense 'polynomial) var terms))

(define (make-polynomial-from-sparse var terms)
  ((get 'make-sparse 'polynomial) var terms))

(install-polynomial-package)

;; Test

(define (tlist p) (apply-generic 'tlist p))
(define (first-term t-list) (apply-generic 'first-term  t-list))
(define (rlist t-list) (apply-generic 'rest-terms  t-list))

(define d-v1 (make-term-list-dense '(1 2 3 4))) ; 

(define d-p1 (make-polynomial-from-dense 'x '(1 1 1))) ; x^2 + x + 1
(define d-p2 (make-polynomial-from-dense 'x '(1 0 1))) ; x^2 + 1
(define d-p3 (make-polynomial-from-dense 'x '(1 0 1 0 1))) ; x^4 + x^2 + 1

(define s-p1 (make-polynomial-from-sparse 'x '((2 1) (1 1) (0 1)))); x^2 + x + 1
(define s-p2 (make-polynomial-from-sparse 'x '((2 1) (0 1)))); x^2 + 1
(define s-p3 (make-polynomial-from-sparse 'x '((4 1) (2 1) (0 1)))) ; x^4 + x^2 + 1

;; Test dense polynomials
(newline)
d-p1
d-p2
d-p3
(add d-p1 d-p1); ✔
(add d-p1 d-p2); ✔
(neg d-p1); ✔
(sub d-p1 d-p1); ✔
(=zero? (sub d-p1 d-p1)); ✔
(=zero? (sub d-p1 d-p2)); ✔
(sub d-p1 d-p2); ✔
(sub d-p2 d-p1); ✔
(mul d-p1 d-p2); ✔
(mul d-p2 d-p2); ✔
(add d-p3 d-p2); ✔

;; Test sparse polynomials
(newline)
(add s-p1 s-p2); ✔
(mul s-p1 s-p2); ✔
(add s-p2 s-p3); ✔


;; Test mixed -- Coercion is not needed thanks to selectors being used
(newline)
(add d-p1 s-p1); ✔
(add s-p1 d-p1); ✔
(mul d-p1 s-p2); ✔
(mul s-p1 d-p2); ✔