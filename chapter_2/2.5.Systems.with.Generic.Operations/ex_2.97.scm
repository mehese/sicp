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


;; Implementation of all to make our life easier

(define (all lst)
  (if (null? lst)
      #t
      (and (car lst) (all (cdr lst)))))

(define (install-number-operation-aliases)
  (define (reduce-integers n d)
    (let ((g (gcd n d)))
      (list (/ n g) (/ d g))))
  
  (define (greatest-common-div a b)
    (if (= b 0)
        a
        (greatest-common-div b (remainder a b))))
  (put 'add '(scheme-number scheme-number) +)
  (put 'sub '(scheme-number scheme-number) -)
  (put 'mul '(scheme-number scheme-number) *)
  (put 'div '(scheme-number scheme-number) /)
  (put '=zero? '(scheme-number) (lambda (x) (= x 0)))
  ;; Just in case we'll need gcd to scheme-number later
  (put 'gcd '(scheme-number scheme-number) greatest-common-div)
  (put 'neg '(scheme-number) (lambda (x) (- x)))
    ;; Don't forget to insert in the the hash table
  (put 'reduce '(scheme-number scheme-number) reduce-integers)

  'done-installing-scheme-operation-aliases)

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (=zero? x) (apply-generic '=zero? x))
(define (neg x) (apply-generic 'neg x))

(install-number-operation-aliases)

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))

  ;; Redefine make rat for problem
  (define (make-rat n d)
    (let ((r (reduce n d)))
      (let
          ((nn (car r))
           (dd (cadr r)))
        (cons nn dd))))

  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'numer '(rational) numer)
  (put 'denom '(rational) denom)
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done-installing-rational-package)

(install-rational-package)
(define (make-rational n d) ((get 'make 'rational) n d))
(define (numer x) (apply-generic 'numer x))
(define (denom x) (apply-generic 'denom x))


(define (find-common-gcd numbers)
  (cond
    ((= 1 (length numbers)) (car numbers))
    ((= 2 (length numbers)) (gcd (car numbers) (cadr numbers)))
    (else (find-common-gcd (cons (gcd (car numbers) (cadr numbers))
                                 (cddr numbers))))))

(define (install-polynomial-package)
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2)(eq? v1 v2)))

  (define (gcd-poly n d)
    (if (same-variable? (variable n) (variable d))
        (make-poly (variable n)
                   (gcd-terms (term-list n) (term-list d)))
        (error "Polys must have same variable")))
  
  (define (gcd-terms a b)
    (if (empty-termlist? b)
        (let ((common-gcd (find-common-gcd (map (lambda (term) (coeff term)) a))))
          (mul-terms-by-constant (div 1 common-gcd) a))
        (gcd-terms b (pseudoremainder-terms a b))))

  (define (reduce-terms n d)
    (let
        ((common-d (gcd-terms n d))
         (c (calculate-integerizing-factor n d)))
      (let
          ((nn-candidate
            (car (div-terms (mul-terms-by-constant c n) common-d)))
           (dd-candidate
            (car (div-terms (mul-terms-by-constant c d) common-d))))
        (let
            ((common-d (find-common-gcd
                        (append (map (lambda (term) (coeff term)) nn-candidate)
                                (map (lambda (term) (coeff term)) dd-candidate)))))
          (list
           (mul-terms-by-constant (div 1 common-d) nn-candidate)
           (mul-terms-by-constant (div 1 common-d) dd-candidate))))))


  (define (reduce-poly n d)
    (if (same-variable? (variable n) (variable d))
        (map
         (lambda (terms) (make-poly (variable n) terms))
         (reduce-terms (term-list n) (term-list d)))
        (error "Polys must have same variable")))

  (define (calculate-integerizing-factor P Q)
    (let
        ((O1 (order (first-term P)))
         (O2 (order (first-term Q)))
         (c  (coeff (first-term Q))))
      (expt c (add 1 (add O1 (neg O2))))))

  (define (mul-terms-by-constant c tlist)
    (map (lambda (term) (make-term (order term) (mul c (coeff term))))
         tlist))

  (define (pseudoremainder-terms a b)
    (let ((c (calculate-integerizing-factor a b)))
      (cadr (div-terms (mul-terms-by-constant c a) b))))
  
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

  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (map (lambda (tlist) (make-poly (variable p1) tlist))
         (div-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: DIV-POLY" (list p1 p2))))  
  
  (define (div-terms L1 L2)
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
                                       (add-terms L1
                                                  (neg-terms
                                                   (mul-term-by-all-terms
                                                          (make-term new-o new-c)
                                                          L2)))
                                       L2)))
                 (list
                  ;; add new term to the rest of the quotient calculated
                  (adjoin-term (make-term new-o new-c) (car rest-of-result)) ;; quotient
                  ;; remainder
                  (cadr rest-of-result))))))))  
  
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))

  ;; If this returns both the result and the remainder, it will break the genericity of div
  (put 'div '(polynomial polynomial)
       (lambda (p1 p2) (tag (car (div-poly p1 p2)))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put '=zero? '(polynomial) is-zero?)
  (put 'gcd '(polynomial polynomial)
       (lambda (p1 p2) (tag (gcd-poly p1 p2))))
  ;; Don't forget to insert in the the hash table
  (put 'reduce '(polynomial polynomial)
       (lambda (p1 p2)
         (map (lambda (p) (tag p)) (reduce-poly p1 p2))))
  'done-installing-polynomial-package)

(install-polynomial-package)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(define (greatest-common-divisor n d) (apply-generic 'gcd n d))
(define (gcd n d) (apply-generic 'gcd n d))

;; Don't forget to declare reduce
(define (reduce n d) (apply-generic 'reduce n d))

;; x^2−2x+1
(define P1 (make-polynomial  'x '((2 1) (1 -2) (0 1))))

;; 11x^2+7
(define P2 (make-polynomial 'x '((2 11) (0 7))))

;; 13x+5
(define P3 (make-polynomial 'x '((1 13) (0 5))))

(display (list "P1 is " P1))(newline)
(display (list "P2 is " P2))(newline)

;; Q1 = 11x^4 - 22x^3 + 18x^2 - 14x + 7
(define Q1 (mul P1 P2))
;; Q2 =         13x^3 - 21x^2 +  3x + 5
(define Q2 (mul P1 P3))
(display "Calculating greatest common divisor of")
(newline)
(display (list "Q1 is " Q1))(newline)
(display (list "Q2 is " Q2))(newline)
;(greatest-common-divisor Q1 Q2)
(reduce Q1 Q2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     2                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; x + 1
(define p1 (make-polynomial 'x '((1 1) (0 1))))

;; x^3 - 1
(define p2 (make-polynomial 'x '((3 1) (0 -1))))

;; x
(define p3 (make-polynomial 'x '((1 1))))

;; x^2 - 1
(define p4 (make-polynomial 'x '((2 1) (0 -1))))

(define rf1 (make-rational p1 p2))
(define rf2 (make-rational p3 p4))
rf1
rf2
(add rf1 rf2)

;; Result
;
;{rational
; {polynomial x {3 -1} {2 -2} {1 -3} {0 -1}}
; polynomial
; x
; {4 -1}
; {3 -1}
; {1 1}
; {0 1}} ; ✔
;
; Not going to bother doing it by hand, but simplified form is similar to
;  https://www.wolframalpha.com/input/?i=((x+%2B+1)%2F+(x%5E3+-+1))+%2B+(x%2F(x%5E2+-+1))
;
; which returns the fraction:
;
;      x^3 + 2x^2 + 3x + 1
;  ---------------------------
;  (x - 1)(x + 1)(x^2 + x + 1)
;
;      x^3 + 2x^2 + 3x + 1
;= ---------------------------
;    (x^2 - 1)(x^2 + x + 1)
;
;      x^3 + 2x^2 + 3x + 1
;= ---------------------------
;       x^4 + x^3 - x - 1
;
;     - x^3 - 2x^2 - 3x - 1
;= ---------------------------  ✔
;     - x^4 - x^3 + x + 1
;
; Which is exactly the result we got above!