#lang sicp

(define (even? n)
  (= 0 (remainder n 2)))

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (inc x)
  (+ x 1))

;; Recursive definition sum
(define (sum-rec term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum-rec term (next a) next b))))

;; Iterative definition sum
(define (sum-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))


;; Recursive definition prod
(define (prod-rec term a next b)
  (if (> a b)
      1
      (* (term a) (prod-rec term (next a) next b))))

;; Iterative definition prod
(define (prod-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

;; Recursive definition
(define (accumulate-rec combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate-rec  combiner null-value term (next a) next b))))

;; Iterative definition
(define (accumulate-iter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (term a) result))))
  (iter a null-value))

(sum-iter identity 1 inc 11)
(sum-rec identity 1 inc 11)
(accumulate-rec + 0 identity 1 inc 11)
(accumulate-iter + 0 identity 1 inc 11)

(sum-iter square 1 inc 11)
(sum-rec square 1 inc 11)
(accumulate-rec + 0 square 1 inc 11)
(accumulate-iter + 0 square 1 inc 11)

(prod-iter identity 1 inc 5)
(prod-rec identity 1 inc 5)
(accumulate-rec * 1 identity 1 inc 5)
(accumulate-iter * 1 identity 1 inc 5)
