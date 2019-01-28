#lang sicp

;; Shitloads of imports

(define (square x) (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate 
                       (cdr sequence))))
        (else  (filter predicate 
                       (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low 
            (enumerate-interval 
             (+ low 1) 
             high))))

(define (make-pair-sum pair)
  (list (car pair) 
        (cadr pair) 
        (+ (car pair) (cadr pair))))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter 
        prime-sum?
        (flatmap
         (lambda (i)
           (map (lambda (j) 
                  (list i j))
                (enumerate-interval 
                 1 
                 (- i 1))))
         (enumerate-interval 1 n)))))

;; Define unique pairs 1<=j<i<=n
(define (unique-pairs n)
  (define (gen-pair i j)
    (cond
      ((= i j) (gen-pair (inc i) 1))
      ((= j (dec n)) (list (list i j)))
      (else (cons (list i j) (gen-pair i (inc j))))))
  (gen-pair 2 1))

;; Redefine prime-sum-pairs
(define (prime-sum-pairs-2 n)
  (map make-pair-sum
       (filter 
        prime-sum?
        (unique-pairs n))))

(prime-sum-pairs 5)
(prime-sum-pairs-2 5) ; ✔

(prime-sum-pairs 10)
(prime-sum-pairs-2 10) ; ✔

