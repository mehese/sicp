#lang sicp

;; Racket hash table
(#%require (only racket/base make-hash))
(#%require (only racket/base hash-set!))
(#%require (only racket/base hash-ref))

(define *op-table* (make-hash))

(define (put op type proc)
  (hash-set! *op-table* (list op type) proc))

(define (get op type)
  (hash-ref *op-table* (list op type) '()))

;; Generic derivative
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) 
           (if (same-variable? exp var) 
               1 
               0))
         (else ((get 'deriv (operator exp)) 
                (operands exp) 
                var))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     1                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The new code is blind to the types of derivative rules available for expressions.
;;  So if we add a new type of operation, say log, we don't need to add a new branc in
;;  the cond of the deriv, as long as our operators table contains a deriv for that operation
;; Variable and exp and not included into the data directed dispatch, as these are independent
;;  of the operations previously appearing. No matter what derivation rules we might want to add
;;  for various functions d(23)/dx = 0, dy/dx = 0 if y is not a function of x, and dx/dx will
;;  always be 1.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     2                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (install-sum-derivative-rule)
  ;; Sum imports
  (define (=number? exp num)
    (and (number? exp) (= exp num)))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list '+ a1 a2))))

  ;; modify selectors, since (operands exp) get passed here, not the whole expression
  (define (addend operands) (car operands))
  (define (augend s)
    (if (null? (cddr s))
        (cadr s) ;; If there's no term, works the same as the above
        (cons '+ (cdr s)))) ;; else return (b + c)

  ;; Register this to our magic table
  (put 'deriv '+
       (lambda
           (exp var)
         (make-sum
          (deriv (addend exp) var)
          (deriv (augend exp) var))))
  'done-installing-sum-derivatives)
(install-sum-derivative-rule)

(deriv '(+ a a 2 2 a a) 'a) ; ✔ 
(deriv '(+ a 2) 'x) ; ✔
(deriv '(+ 1 2) 'a) ; ✔

(define (install-prod-derivative-rule)
  ;; Product imports
  (define (=number? exp num)
    (and (number? exp) (= exp num)))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0)
               (=number? m2 0))
           0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2))
           (* m1 m2))
          (else (list '* m1 m2))))

  ;; Redefine multiplicand and multiplier, as we pass the operands not the full expression
  (define (multiplier p) (car p))
  (define (multiplicand p)
    (if (null? (cddr p))
      (cadr p) 
      (cons '* (cdr p))))

  ;; Register this to our magic table
  (put 'deriv '*
       (lambda
           (exp var)
         (make-sum
          (make-product 
           (multiplier exp)
           (deriv (multiplicand exp) var))
          (make-product 
           (deriv (multiplier exp) var)
           (multiplicand exp)))))
  'done-installing-prod-derivatives)
(install-prod-derivative-rule)

(deriv '(* x y) 'x) ; ✔
(deriv '(* a a a a a) 'x) ; ✔
(deriv '(* a a a x) 'x) ; ✔
(deriv '(* x x x) 'x) ; ✔
(deriv '(* x x) 'x) ; ✔ 
(deriv '(+ (* a x 2) x 2)  'x) ; ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     3                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (install-expt-derivative-rule)
  ;; Exponentiation imports
  (define (=number? exp num)
    (and (number? exp) (= exp num)))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2))
           (* m1 m2))
          (else (list '* m1 m2))))
  (define (make-exponentiation b n)
    (cond
      ((=number? n 0) 1)
      ((=number? n 1) b)
      ((and (number? b) (number? n) (expt b n)))
      (else (list '** b n))))
  
  ;; Redefine multiplicand and multiplier, as we pass the operands not the full expression=
  (define (get-base p) (car p))
  (define (get-exponent p) (cadr p))
  
  ;; Register this to our magic table
  (put 'deriv '**
       (lambda
           (exp var)
            (let
             ((expnt (get-exponent exp))
              (base (get-base exp)))
           (make-product
            (make-product
             expnt
             (make-exponentiation base (make-sum expnt -1)))
            (deriv base var)))))
  'done-installing-expt-derivatives)
(install-expt-derivative-rule)

(deriv '(** u n) 'u) ; ✔
(deriv '(** (* y x) n) 'x) ; ✔
(deriv '(+ (* a x) (** x (- n 1))) 'x); ✔
(deriv '(** (+ a x x b) n) 'x); ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     4                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; New derivative
(define (deriv-new exp var)
   (cond ((number? exp) 0)
         ((variable? exp) 
           (if (same-variable? exp var) 1 0))
         (else ((get (operator exp) 'deriv) 
                (operands exp) 
                var))))

;; Import the same, except with swapped symbol expression

(define (install-reverse-derivative-rule)
  ;; Basic imports
  (define (=number? exp num)
    (and (number? exp) (= exp num)))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2))
           (* m1 m2))
          (else (list '* m1 m2))))
  (define (make-exponentiation b n)
    (cond
      ((=number? n 0) 1)
      ((=number? n 1) b)
      ((and (number? b) (number? n) (expt b n)))
      (else (list '** b n))))
  
  ;; Selectors
  (define (addend operands) (car operands))
  (define (augend s) (if (null? (cddr s)) (cadr s) (cons '+ (cdr s))))
  (define (multiplier p) (car p))
  (define (multiplicand p) (if (null? (cddr p)) (cadr p) (cons '* (cdr p))))  
  (define (get-base p) (car p))
  (define (get-exponent p) (cadr p))
  
  ;; Register the above for deriv-new
  (put '+ 'deriv
       (lambda
           (exp var)
         (make-sum
          (deriv-new (addend exp) var)
          (deriv-new (augend exp) var))))
  (put '* 'deriv
       (lambda
           (exp var)
         (make-sum
          (make-product 
           (multiplier exp)
           (deriv-new (multiplicand exp) var))
          (make-product 
           (deriv-new (multiplier exp) var)
           (multiplicand exp)))))  
  (put '** 'deriv 
       (lambda
           (exp var)
            (let
             ((expnt (get-exponent exp))
              (base (get-base exp)))
           (make-product
            (make-product
             expnt
             (make-exponentiation base (make-sum expnt -1)))
            (deriv-new base var)))))
  'done-installing-reverse-derivatives)
(install-reverse-derivative-rule)

(deriv-new '(+ a a 2 2 a a) 'a) ; ✔ 
(deriv-new '(+ a 2) 'x) ; ✔
(deriv-new '(+ 1 2) 'a) ; ✔
(newline)
(deriv-new '(* x y) 'x) ; ✔
(deriv-new '(* a a a a a) 'x) ; ✔
(deriv-new '(* a a a x) 'x) ; ✔
(deriv-new '(* x x x) 'x) ; ✔
(deriv-new '(* x x) 'x) ; ✔ 
(deriv-new '(+ (* a x 2) x 2)  'x) ; ✔
(newline)
(deriv-new '(** u n) 'u) ; ✔
(deriv-new '(** (* y x) n) 'x) ; ✔
(deriv-new '(+ (* a x) (** x (- n 1))) 'x); ✔
(deriv-new '(** (+ a x x b) n) 'x); ✔