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

(define (attach-tag type-tag contents)
  (cond
    ((pair? contents) (cons type-tag contents))
    ((number? contents) (cons type-tag contents))
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
(define (sub x y) (apply-generic 'sub x y))
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

(define (type-tag datum)
  (cond
    ((pair? datum) (car datum))
    ((integer? datum) 'scheme-number)
    ((real? datum) 'real)
    (else (error "Bad tagged datum: TYPE-TAG" datum))))

(define (install-real-number-package)
  (define (tag x)
    (attach-tag 'real x))
  (put 'add '(real real)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(real real)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(real real)
       (lambda (x y) (tag (* x y))))
  (put 'div '(real real)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? '(real real)
       (lambda (x y) (= x y)))
  ;; check zero
  (put '=zero? '(real)
       (lambda (x) (= x 0)))
  (put 'make 'real
       (lambda (x) (tag x)))
  ;; Problem implementation
  (put 'exp '(real real) (lambda (x y) (tag (expt x y))))
  'done-installing-real-number-package)
(install-real-number-package)

(define (make-real x) ((get 'make 'real) x))

(define (scheme-number->rational x)
  (make-rational (contents x) 1))

(define (rational->real ra)
  (make-real (* (numer ra) (/ 1.0 (denom ra)))))

(define (real->complex re)
  (make-complex-from-real-imag (contents re) 0))

(put-coercion 'raise 'scheme-number scheme-number->rational)
(put-coercion 'raise 'rational rational->real)
(put-coercion 'raise 'real real->complex)

(define (raise number)
  (let ((transform (get-coercion 'raise (type-tag number))))
    (if transform
        (transform number)
        #f)))

(define s1 (make-scheme-number 2))
(define ra1 (make-rational 2 3))
(define re1 (make-real 3.1))
(define c1 (make-complex-from-real-imag 3 4))

;; Problem
;; Needed to make modifications to attach-tag and type-tag 

(define type-hierarchy '(scheme-number rational real complex))

(define (lower-type type1 type2)
  (define (lt lst)
    (if (null? lst)
        (error "Types given not found in hierarchy" (list type1 type2))
        (let ((this-type (car lst)))
          (cond
            ((eq? type1 this-type) type1)
            ((eq? type2 this-type) type2)
            (else (lt (cdr lst)))))))
  (lt type-hierarchy))


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (cond
            ((= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                ;; check which of the type is lower
                (cond
                   ; types are the same
                   ((eq? type1 type2)
                    (error "Arguments have the same type, but procedure isn't defined for them"))
                   ;type1 needs raising
                   ((eq? type1 (lower-type type1 type2))
                    (apply-generic op (raise a1) a2))
                   ;type2 needs raising
                   ((eq? type2 (lower-type type1 type2))
                    (apply-generic op a1 (raise a2)))
                   (else (error "No method for  these types" (list op type-tags))))))
            ((> (length args) 2)
             (let ((new-arg (apply-generic op (car args) (cadr args))))
               (apply apply-generic
                      (append (list op new-arg) (cddr args)))))               
            (else (error "No method for these types" (list op type-tags))))))))

(define (add . args) (apply apply-generic (cons 'add args)))

(add ra1 ra1); ✔
(add s1 s1); ✔
(add c1 c1); ✔

(add s1 ra1); ✔
(add ra1 s1); ✔
(add s1 re1); ✔
(add re1 s1); ✔
(add re1 c1); ✔
(add c1 re1); ✔
(add s1 c1); ✔
(add c1 s1); ✔