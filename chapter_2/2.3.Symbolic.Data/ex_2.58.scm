#lang sicp

;; What works for part 2 of the problem also works for part 1

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) 
             (=number? m2 0)) 
         0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) 
         (* m1 m2))
        (else (append (list m1) (list '*) (list m2)))))
(define (make-exponentiation b n)
  (cond
    ((=number? n 0) 1)
    ((=number? n 1) b)
    ((and (number? b) (number? n) (expt b n)))
    (else (list b '** n))))

(define (sum? x)
  (and
   (pair? x)
   (if (eq? (memq '+ x) #f)
       #f
       #t)))
       

(define (list-left-of sym lst)
  (cond
    ((null? lst) '())
    ((eq? sym (car lst)) '())
    (else (append (list (car lst))  (list-left-of sym (cdr lst))))))

(define (addend s)
  (let
      ((left (list-left-of '+ s)))
    (if (= 1 (length left))
        (car left)
        left)))
        

(define (augend s)
  (let
      ((right (cdr (memq '+ s))))
    (if (= 1 (length right))
        (car right)
        right)))

(define (product? x)
  (and
   (pair? x)
   (if (eq? (memq '* x) #f)
       #f
       #t)))

(define (multiplier p)
  (let
      ((left (list-left-of '* p)))
    (if (= 1 (length left))
        (car left)
        left)))

(define (multiplicand p)
  (let
      ((right (cdr (memq '* p))))
    (if (= 1 (length right))
        (car right)
        right)))

(define (product-rule exp var)
  (make-sum
          (make-product 
           (multiplier exp)
           (deriv (multiplicand exp) var))
          (make-product 
           (deriv (multiplier exp) var)
           (multiplicand exp))))

;; This is easier if working 
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ;; Order of conditions is important!
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp) (product-rule exp var))
        (else (error "unknown expression 
                      type: DERIV" exp))))

(deriv '(a + x) 'x)
(deriv '(a + x + c) 'x)
(deriv '(a + x) 'a)

(deriv '(x + ((a + x) + (y + x))) 'x) ; ✔
(deriv '(x + (a + x + y + x)) 'x) ; ✔
(deriv '(x + (a + x + y + x)) 'z) ; ✔

(display "test product") (newline)

(deriv '((a * x) + ((b * x) + (x * c))) 'x) ; ✔ 
(deriv '(x + (3 * (x + (y + 2)))) 'x) ; ✔
(deriv '(x + 3 * (x + y + 2)) 'x) ; ✔

(deriv '(a + b + d + (e * x)) 'x) ; ✔

(deriv '(a * b * x) 'x) ; ✔

(deriv '(a + b * x + c) 'x) ; ✔

(deriv '(a + b * c * x  + d) 'x) ; ✔

(deriv '(a + b * x * x) 'x) ; ✔

(deriv '(a + (b * x * x) + c) 'x) ; ✔

;; Nearly considered this problem done before checking these babies out
(deriv '(b * x * x + c) 'x) ; ✔
(deriv '(a + b * x * x + c) 'x) ; ✔

