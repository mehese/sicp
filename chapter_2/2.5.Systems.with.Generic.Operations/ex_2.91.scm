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

;; Tags and applys
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

;; Just using the regular apply generic, let's not confuse stuff with drops
;;  and raises
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

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (=zero? x) (apply-generic '=zero? x))
(define (neg x) (apply-generic 'neg x))

(install-number-operation-aliases)

(define (all lst)
  (if (null? lst)
      #t
      (and (car lst) (all (cdr lst)))))

;; Package installation implementation
(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2)(eq? v1 v2)))

  (define (all-terms terms)
    (if (empty-termlist? terms)
        (the-empty-termlist)
        (cons (first-term terms) (all-terms (rest-terms terms)))))
  
  ;; Not naming it =zero? because it then becomes hard to call
  ;;  the *generic* =zero? for verifying the individual terms
  (define (is-zero? p)
    (all (map (lambda (term) (=zero? (coeff term))) (all-terms (term-list p)))))
    
  (define (adjoin-term term term-list)
    (if (= (order term) (length term-list))
        (cons (coeff term) term-list)
        (adjoin-term term
                     (adjoin-term
                      (make-term (length term-list) 0)
                      term-list))))

  (define (the-empty-termlist) '())
  (define (first-term term-list)
    (make-term (dec (length term-list)) (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
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
        (the-empty-termlist)
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
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term (make-term (+ (order t1) (order t2))
                                  (mul (coeff t1) (coeff t2)))
                       (mul-term-by-all-terms t1 (rest-terms L))))))

  ;; Problem

  ;; my adjoin-term can add zero coeff terms, which results in an endless loop
  ;;  this solution is probably not what the SICP authors intended, but it works
  (define (simplify-term-list term-list)
    (if (not (=zero? (coeff (first-term term-list))))
        term-list
        (simplify-term-list (rest-terms term-list))))
  
  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (map (lambda (tlist) (make-poly (variable p1) tlist))
         (div-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: DIV-POLY" (list p1 p2))))  

  (define (div-terms L1 L2)
    (display (list L1 L2))
    (newline)
    (if (empty-termlist? L1)
        (list (the-empty-termlist) 
              (the-empty-termlist))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
          (if (> (order t2) (order t1))
              (list (the-empty-termlist) L1)
              (let ((new-c (div (coeff t1) (coeff t2)))
                    (new-o (- (order t1) (order t2))))
                (let ((rest-of-result (div-terms
                                       (simplify-term-list
                                        (add-terms L1
                                                  (neg-terms
                                                   (mul-term-by-all-terms
                                                          (make-term new-o new-c)
                                                          L2))))
                                       L2)))
                 (list
                  ;; add new term to the rest of the quotient calculated
                  (adjoin-term
                   (make-term new-o new-c)
                   (car rest-of-result)) ;; quotient
                  ;; remainder
                  (cadr rest-of-result))))))))  

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
  ;; Don't forget to add it to the ops table
  (put 'div '(polynomial polynomial)
       (lambda (p1 p2) (map tag (div-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put '=zero? '(polynomial) is-zero?)
  'done)

(install-polynomial-package)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(define p-divident-1 (make-polynomial 'x '(1 0 0 0 0 -1))) ;; x^5 - 1
(define p-divisor-1 (make-polynomial 'x '(1 0 -1))) ;; x^2 - 1
(define p-quot-1 (make-polynomial 'x '(1 0 0 1))) ;; x^3 - 1
(define p-rem-1 (make-polynomial 'x '(1 -1))) ;; x - 1

(define p-divident-2 (make-polynomial 'x '(3 -1 -3 1 5))) ;; 3x^4 - x^3 - 3x^2 + x + 5
(define p-divisor-2 (make-polynomial 'x '(1 -1 0)))

(define x^3-1 (make-polynomial 'x '(1 0 0 -1)))
    
(=zero? (sub p-divident-1
             (add (mul p-divisor-1 p-quot-1) p-rem-1)))

(=zero? (car (div p-divisor-1 p-quot-1)))


(div p-divident-1 p-divisor-1); ✔
(div x^3-1 p-divisor-1); ✔
(div p-divident-2 p-divisor-2); ✔