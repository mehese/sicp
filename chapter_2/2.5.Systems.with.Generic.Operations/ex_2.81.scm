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
(define (square x) (* x x))

(define (type-tag datum)
  (cond
    ((pair? datum) (car datum))
    ((number? datum) 'scheme-number)
    (else (error "Bad tagged datum: TYPE-TAG" datum))))

(define (attach-tag type-tag contents)
  (cond
    ((pair? contents) (cons type-tag contents))
    ((number? contents) contents)
    (else (error "What are you trying to tag here? Ain't a pair and ain't a number"))))

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
       (lambda (x y) (tag (/ x y))))
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

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) 
    (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))
  ;; interface to the rest of the system
  (define (tag x) 
    (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done-installing-rectangular-package)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done-installing-rectangular-package)

(define (install-complex-package)
  ;; imported procedures from rectangular 
  ;; and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 
          'rectangular) 
     x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) 
     r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag 
     (+ (real-part z1) (real-part z2))
     (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag 
     (- (real-part z1) (real-part z2))
     (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang 
     (* (magnitude z1) (magnitude z2))
     (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang 
     (/ (magnitude z1) (magnitude z2))
     (- (angle z1) (angle z2))))
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
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
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  (put 'equ? '(complex complex)
       (lambda (c1 c2)
         (and (= (real-part c1) (real-part c2)) (= (imag-part c1) (imag-part c2)))))
  ;; zero check implementation
  (put '=zero? '(complex)
       (lambda (c)
         (and (= (real-part c) 0) (= (imag-part c) 0))))
  'done-installing-complex-package)

(define (make-scheme-number n) ((get 'make 'scheme-number) n))
(define (make-rational n d) ((get 'make 'rational) n d))
(define (make-complex-from-real-imag x y) ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a) ((get 'make-from-mag-ang 'complex) r a))

(install-scheme-number-package)
(install-rational-package)
(install-polar-package)
(install-rectangular-package)
(install-complex-package)
(define (numer x)     (apply-generic 'numer x))
(define (denom x)     (apply-generic 'denom     x))
(define (real-part x) (apply-generic 'real-part x))
(define (imag-part x) (apply-generic 'imag-part x))
(define (magnitude x) (apply-generic 'magnitude x))
(define (angle x)     (apply-generic 'angle     x))
(define (equ? num1 num2) (apply-generic 'equ? num1 num2))
(put 'real-part '(complex) real-part)
(put 'imag-part '(complex) imag-part)
(put 'magnitude '(complex) magnitude)
(put 'angle '(complex) angle)

;(define (apply-generic op . args)
;  (let ((type-tags (map type-tag args)))
;    (let ((proc (get op type-tags)))
;      (if proc
;          (apply proc (map contents args))
;          (if (= (length args) 2)
;              (let ((type1 (car type-tags))
;                    (type2 (cadr type-tags))
;                    (a1 (car args))
;                    (a2 (cadr args)))
;                (let ((t1->t2 (get-coercion type1 type2))
;                      (t2->t1 (get-coercion type2 type1)))
;                  (cond (t1->t2
;                         (apply-generic op (t1->t2 a1) a2))
;                        (t2->t1
;                         (apply-generic op a1 (t2->t1 a2)))
;                        (else
;                         (error "No method for  these types" (list op type-tags))))))
;              (error "No method for these types" (list op type-tags)))))))


;; Problem

;; Comment out for sections 2 & 3
;(define (scheme-number->scheme-number n) n)
;(define (complex->complex z) z)

;(put-coercion 'scheme-number 'scheme-number
;              scheme-number->scheme-number)

;(put-coercion 'complex 'complex 
;              complex->complex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     1                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(define (exp x y) (apply-generic 'exp x y))

(define c1 (make-complex-from-real-imag 3 4))
(define i (make-complex-from-mag-ang 1 0))
(define j (make-complex-from-real-imag 0 1))

;; Below causes ∞ loop as each time a complex number will cast to complex and call
;;  apply-generic with complex arguments
; (exp i j)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     2                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Works for scheme-numbers, or when coersions exist as designed

;(exp (make-scheme-number 2) (make-scheme-number 3))

(define (rational->scheme-number r)
  ;; Requires numer and denom to be made public by the rational number package
  (let
      ((p (numer r))
       (q (denom r)))
    (if (= 0 (remainder p q))
        (make-scheme-number (/ p q))
        (error "Cannot convert the following to integer" (list p q)))))

(define (scheme-number->rational n)
  (make-rational n 1))

(put-coercion 'rational 'scheme-number rational->scheme-number)
(put-coercion 'scheme-number 'rational  scheme-number->rational)


;(exp (make-rational 2 1) 3)

;; Still, would want to modify so apply-generic doesn't try coercion if two arguments
;;  have the same type

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     3                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
                (if (eq? type1 type2)
                    (error "Arguments have the same type, but procedure isn't defined for them")
                    (let ((t1->t2 (get-coercion type1 type2))
                          (t2->t1 (get-coercion type2 type1)))
                      (cond (t1->t2
                             (apply-generic op (t1->t2 a1) a2))
                            (t2->t1
                             (apply-generic op a1 (t2->t1 a2)))
                            (else
                             (error "No method for  these types" (list op type-tags)))))))
              (error "No method for these types" (list op type-tags)))))))

(define (add x y) (apply-generic 'add x y))
(add 2 3)