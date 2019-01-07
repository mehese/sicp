#lang sicp

(define (even? n)
  (= 0 (remainder n 2)))

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (inc x)
  (+ x 1))


;; Recursive definition (point 1)
(define (prod-rec term a next b)
  (if (> a b)
      1
      (* (term a) (prod-rec term (next a) next b))))

;; Iterative definition (point 2)
(define (prod-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (wallis-term n)
  (if (even? n)
      (/ (+ n 2) (+ n 1))
      (/ (+ n 1) (+ n 2))))

(define (pi-approx n)
  (* 4.0 (prod-rec wallis-term 1 inc n)))

(define (pi-approx-2 n)
  (* 4.0 (prod-iter wallis-term 1 inc n)))


(prod-rec identity 1 inc 5); 120 = 5!
(prod-rec identity 1 inc 10); = 3628800 = 10!

(prod-iter identity 1 inc 5); 120 = 5!
(prod-iter identity 1 inc 10); = 3628800 = 10!

(pi-approx 2000) ; ~ 3.14
(pi-approx-2 2000) ; ~ 3.14