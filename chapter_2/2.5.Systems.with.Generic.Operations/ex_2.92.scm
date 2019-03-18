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
  (put '=zero? '(scheme-number) (lambda (x) (= x 0)))

  'done-installing-scheme-operation-aliases)

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (=zero? x) (apply-generic '=zero? x))

(install-number-operation-aliases)

(define (all lst)
  (if (null? lst)
      #t
      (and (car lst) (all (cdr lst)))))

(define VARIABLE-HIERARCHY '(a b c x y z A B C X Y Z))

(define (lowest-in-hierarchy s1 s2)
  (define (iter-hierarchy h-lst)
    (cond
      ((null? h-lst) (error "Neither symbol was found in variable hierarchy"))
      ((eq? s1 (car h-lst)) s1)
      ((eq? s2 (car h-lst)) s2)
      (else (iter-hierarchy (cdr h-lst)))))
  (iter-hierarchy VARIABLE-HIERARCHY))

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
  
  ;; Not naming it =zero? because it then becomes hard to call
  ;;  the *generic* =zero? for verifying the individual terms
  (define (is-zero? p)
    (cond
      ((null? (term-list p)) #t)
      ((all (map (lambda (term) (=zero? (coeff term))) (term-list p))))
      (else #f)))
    
  (define (adjoin-term term term-list)
  (if (=zero? (coeff term))
      term-list
      (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (recast-term-to-var term new-var old-var)
    (let
        ((c (coeff term))
         (o (order term)))
      (cond
        ;; The term is a polynomial in the same variable as the new variable
        ((and (eq? (type-tag c) 'polynomial) (eq? (variable (contents c)) new-var))
          ;; The term is a polynomial that needs work
           (make-poly new-var
                       (map (lambda (t)
                              (make-term (order t)
                                         (make-polynomial old-var
                                                          (list (make-term o (coeff t))))))
                            (term-list (contents c)))))
        ;; The term is a polynomial but in a different variable
        ((and (eq? (type-tag c) 'polynomial) (not (eq? (variable? (contents c)) new-var)))
          ;; Not gonna bother with this case, would need a stronger representation implementation
          (error "Not bothering with this lol"))
        ;; The term is a simple scheme number
        ((eq? (type-tag c) 'scheme-number)
         (make-poly new-var
                    (list
                     ;; The zero order term is a polynomial in the old var with a single term
                     ;;   5y^2 {poly y ((2 5))}
                     ;;   -> {poly x ((0 {poly y ((2 5))}))
                     (make-term 0
                                (make-polynomial old-var  (list (make-term o c))))))))))

  (define (recast-poly-to-var p new-var)
    (if (is-zero? p)
        (make-poly new-var '())
        (let
            ((terms (term-list p))
             (old-var (variable p)))
          (add-poly
           (recast-term-to-var (first-term terms) new-var old-var)
           (make-poly old-var
                      (rest-terms terms))))))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
         (make-poly (variable p1)
                    (add-terms (term-list p1) (term-list p2)))
        (let
            ((v1 (variable p1))
             (v2 (variable p2)))
          (if (eq? v1 (lowest-in-hierarchy v1 v2))
              (add-poly p1 (recast-poly-to-var p2 v1))
              (add-poly (recast-poly-to-var p1 v2) p2)))))

  (define (add-number-to-poly n p)
    (define (fix-last-term tlist)
      (cond
        ((null? tlist)
         (list (make-term 0 n)))
        ((= 0 (order (first-term tlist)))
         (list (make-term 0 (add n (coeff (first-term tlist))))))
        (else
         (cons (first-term tlist) (fix-last-term (rest-terms tlist))))))

    (make-poly (variable p) (fix-last-term (term-list p))))
  
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

  (define (mul-poly-by-constant c p1)
    (make-poly (variable p1)
               (map (lambda (term) (make-term (order term)
                                              (mul c (coeff term)))) (term-list p1))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term (make-term (+ (order t1) (order t2))
                                  (mul (coeff t1) (coeff t2)))
                       (mul-term-by-all-terms t1 (rest-terms L))))))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'add '(scheme-number polynomial)
       (lambda (n p) (tag (add-number-to-poly n p))))
  (put 'add '(polynomial scheme-number)
       (lambda (p n) (tag (add-number-to-poly n p))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'mul '(scheme-number polynomial)
       (lambda (c p2) (tag (mul-poly-by-constant c p2))))
  (put 'mul '(polynomial scheme-number)
       (lambda (p2 c) (tag (mul-poly-by-constant c p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  ;; Don't forget to insert in the the hash table
  (put '=zero? '(polynomial) is-zero?)
  'done)

(install-polynomial-package)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

;; (x^2 + 1)y^2 + 3y + 1
(define p1 (make-polynomial 'y (list (list 2 (make-polynomial 'x '((2 1) (0 1))))
                                     '(1 3)
                                     '(0 1))))

;; x^2 + (y^2 + y + 1)x
(define p2 (make-polynomial 'x (list '(2 1)
                                     (list 1 (make-polynomial 'y '((2 1) (1 1) (0 1)))))))

(define p3 (make-polynomial 'x '((2 1) (1 1) (0 1))))
(define one-x-something (make-polynomial 'x (list '(1 1)
                                                  (list 0 (make-polynomial 'y '((2 1) (1 1) (0 1)))))))
(define zero-y (make-polynomial 'y '()))
(define one-y (make-polynomial 'y '((1 1))))
(define xy (make-polynomial 'x (list
                               (list 1 (make-polynomial 'y '((1 1)))))))
(define yx2 (make-polynomial 'y (list
                                 (list 1 (make-polynomial 'x '((2 1)))))))
(define y2x (make-polynomial 'y (list
                                 (list 2 (make-polynomial 'x '((1 1)))))))

(add one-x-something one-y); ✔
(add xy yx2); ✔
(add xy y2x); ✔
(newline) (newline)
p2
p1
(add p2 p1); ✔
(add p1 p2); ✔
