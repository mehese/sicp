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

;; A ton of imports
(define (attach-tag type-tag contents)
  (cond
    ((pair? contents) (cons type-tag contents))
    ((number? contents) (cons type-tag contents))
    (else (error "What are you trying to tag here? Ain't a pair and ain't a number"))))

(define (type-tag datum)
  (cond
    ((pair? datum) (car datum))
    ((integer? datum) 'scheme-number)
    ((real? datum) 'real)
    (else (error "Bad tagged datum: TYPE-TAG" datum))))

(define (contents datum)
  (cond
    ((pair? datum) (cdr datum))
    ((number? datum) datum)
    (else (error "Bad tagged datum: CONTENTS" datum))))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y)
         ;; Didn't  realise this needed modifying until now
         (if (integer? (/ x y))
                       (tag (/ x y))
                       (make-rational x y))))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))
  ;; check zero
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0)))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  ;; Problem implementation
  (put 'exp '(scheme-number scheme-number) (lambda (x y) (tag (expt x y))))
  'done-installing-scheme-number-package)

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put 'equ? '(rational rational) (lambda (x y) (and (= (numer x) (numer y)) (= (denom x) (denom y)))))
  (put '=zero? '(rational) (lambda (x) (= (numer x) 0)))

  ;; need to have numer there
  (put 'numer '(rational) (lambda (x) (numer x)))
  (put 'denom '(rational) (lambda (x) (denom x)))
  'done-installing-rational-package)

(install-scheme-number-package)
(install-rational-package)
(define (make-scheme-number n) ((get 'make 'scheme-number) n))
(define (make-rational n d) ((get 'make 'rational) n d))
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))


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

;; Problem

;; naming them sine and cosine, as to not override the defaults
(define (install-sine-and-cosine-for-scheme-and-rat)
  (define (sine-scheme number)
    (sin (contents number)))
  
  (define (cosine-scheme number)
    (cos (contents number)))

  (define numer (get 'numer '(rational)))
  (define denom (get 'denom '(rational)))

  (define (sine-rational number)
    (let
        ((p (numer number))
         (q (denom number)))
      (sin (/ p q))))

  (define (cosine-rational number)
    (let
        ((p (numer number))
         (q (denom number)))
      (cos (/ p q))))
  
  (put 'sine '(scheme-number) sine-scheme)
  (put 'cosine '(scheme-number) cosine-scheme)
  (put 'sine '(rational) sine-rational)
  (put 'cosine '(rational) cosine-rational)
  'done-installing-sine-cosine)

(install-sine-and-cosine-for-scheme-and-rat)
(define (sine x) (apply-generic 'sine x))
(define (cosine x) (apply-generic 'cosine x))
(define (tangent x) (/ (sine x) (cosine x)))
(define (square x) (mul x x))

(define (install-complex-package)
  ;; Let's have our own constructors
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (magnitude z)
    (add (square (real-part z))
         (square (imag-part z))))
  (define (angle z)
    (tangent (real-part z)))
    
    
  (define (make-from-ri x y) 
    (cons x y))
  (define (make-from-mag-ang r a)
    (cons (* r (cosine a)) (* r (cosine a))))

  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-ri 
     (add (real-part z1) (real-part z2))
     (add (imag-part z1) (imag-part z2))))
  
  (define (sub-complex z1 z2)
    (make-from-ri 
     (sub (real-part z1) (real-part z2))
     (sub (imag-part z1) (imag-part z2))))

  ;; I've no intention of implementing atan for the custom types
  ;;  so these need reformulating
  
  (define (mul-complex z1 z2)
    (let
        ((a (real-part z1))
         (b (imag-part z1))
         (c (real-part z2))
         (d (imag-part z2)))
      (make-from-ri
       (sub (mul a c) (mul b d))
       (add (mul a d) (mul b c)))))
  
  (define (div-complex z1 z2)
    (let
        ((a (real-part z1))
         (b (imag-part z1))
         (c (real-part z2))
         (d (imag-part z2))
         (m (magnitude z2)))
      (make-from-ri
       (div (add (mul a c) (mul b d)) m)
       (div (sub (mul b c) (mul a d)) m))))
 
  
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))

  (put 'imag-part '(complex) imag-part)
  (put 'real-part '(complex) real-part)

  (put 'add '(complex complex)
       (lambda (z1 z2) 
         (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) 
         (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) 
         (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) 
         (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) 
         (tag (make-from-ri x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))

  'done-installing-complex-package)

(install-complex-package)
(define (make-from-real-imag x y) ((get 'make-from-real-imag 'complex) x y))
(define (make-from-mag-ang x y) ((get 'make-from-mag-ang 'complex) x y))
(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))

(define s1 (make-scheme-number 2))
(define s2 (make-scheme-number 3))
(define r1 (make-rational 3 2))
(define r2 (make-rational 1 2))

(define z1 (make-from-real-imag s1 s2))
(define z1-conj (make-from-real-imag s1 (make-scheme-number -3)))
(define z2 (make-from-real-imag s1 s1))
(define i (make-from-real-imag (make-scheme-number 1) (make-scheme-number 0)))

(mul z1 z1-conj); ✔
(div z1 z1); ✔
(mul z1 z2); ✔
(div z1 z1-conj); ✔
(add z1 z1-conj); ✔
(sub z1 z1-conj); ✔
(real-part z1); ✔
(real-part z1-conj); ✔
(imag-part z1); ✔
(imag-part z1-conj); ✔
(add z1 i); ✔
(sub z1 z2); ✔