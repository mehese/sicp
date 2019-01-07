#lang sicp

(define (average a b)
  (/ (+ a b) 2))

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))


(fixed-point cos 1.0)

(define (sqrt x)
  (fixed-point 
   (lambda (y) (average y (/ x y)))
   1.0))

(sqrt 2)

(define phi
  (let ((x0 2.0))
    (fixed-point (lambda (x) (+ 1 (/ 1 x))) x0)))

phi ; ≈1.6180

;; by definition
;; φ²=φ+1
;; → φ = 1 + 1/φ
;; 
;; Let's test if φ is a fixed point for
;; x ↦ 1 + 1/x
;; ⟺  f(x) = 1 + 1/x
;; ⟹  f(φ) = 1 + 1/φ
;; ⟹  f(φ) = 1 + 1/((1 + √5)/2)
;; ⟹  f(φ) = (1 + √5 + 2)/(1 + √5) | multiply and divide the right hand side by (1 - √5)
;; ⟹  f(φ) = ((3 + √5)(1 - √5))/((1 + √5)(1 - √5))
;; ⟹  f(φ) = ((3 + √5)(√5 - 1))/4
;; ⟹  f(φ) = (3√5 - 3 + 5 -√5)/4
;; ⟹  f(φ) = (3√5 - 3 + 5 -√5)/4
;; ⟹  f(φ) = (2 + 2√5)/4
;; ⟹  f(φ) = (1 + 1√5)/2
;; ⟹  f(φ) = φ QED!
