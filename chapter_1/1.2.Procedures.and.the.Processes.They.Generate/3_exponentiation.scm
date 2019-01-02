#lang sicp

(define (expt b n)
  (if (= n 0) 
      1 
      (* b (expt b (- n 1)))))

(define (expt2 b n) 
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b
                 (- counter 1)
                 (* b product))))

(define (square x)
  (* x x))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast-expt b n)
  (cond ((= n 0) 
         1)
        ((even? n) 
         (square (fast-expt b (/ n 2))))
        (else 
         (* b (fast-expt b (- n 1))))))


(define (compare-exp b n)
  (list (expt b n) (expt2 b n) (fast-expt b n)))

(compare-exp 1 100)
(compare-exp 2 5)
(compare-exp 3 4)
(compare-exp 5 5)