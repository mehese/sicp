#lang sicp

(define (square x)
  (* x x))

(define (prime? n)
  (define (iter x)
    (cond
      ((> (square x) n) #t)
      ((= (remainder n x) 0) #f) ; is not prime if r(n%x)=0
      (else (iter (+ x 1)))))
  (iter 2))

(define (relatively-prime? a n)
  (define (iter x)
    (cond
      ((> x a) #t)
      ((> x n) #t)
      ((and
        (= 0 (remainder n x))
        (= 0 (remainder a x))) #f)
      (else (iter (+ x 1)))))
  (cond
    ((< a 2) #t)
    ((= 0 (remainder n a)) #f)
    (else (iter 2))))


;; Recursive accumulate
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate  combiner null-value term (next a) next b))))

(define (filtered-accumulate combiner null-value term a next b filter?)
  (cond
    ((> a b) null-value)
    ((filter? a) (combiner (term a) (filtered-accumulate combiner null-value term (next a) next b filter?)))
    (else (combiner null-value (filtered-accumulate combiner null-value term (next a) next b filter?)))))

(prime? 11383)
(relatively-prime? 12 15)
(relatively-prime? 14 15)
(relatively-prime? 20 5)
(relatively-prime? 20 7)
(relatively-prime? 13 15)


;; Test filtered-accumulate
(filtered-accumulate + 0 identity 1 inc 11 prime?) 
(+ 1 2 3 5 7 11)

(filtered-accumulate + 0 square 1 inc 11 prime?) ;; sum squares primes between 1 and 11
(+ 1 4 9 25 49 121)

(filtered-accumulate * 1 square 1 inc 11 prime?)
(* 1 4 9 25 49 121)

(define (relatively-prime-to-20? x)
  (relatively-prime? x 20)) ; later I suspect SICP will teach me to return an elegant lambda

(filtered-accumulate * 1 identity 1 inc 20 relatively-prime-to-20?)
(* 1 3 7 9 11 13 17 19)

(define (relatively-prime-to-30? x)
  (relatively-prime? x 30))

(filtered-accumulate * 1 identity 1 inc 30 relatively-prime-to-30?)
(* 1 7 11 13 17 19 23 29)