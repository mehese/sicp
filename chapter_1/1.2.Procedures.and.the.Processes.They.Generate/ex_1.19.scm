#lang sicp

;; Use this naive version to check the results
(define (fib-ref n)
  (cond
    ((= n 1) 1)
    ((= n 2) 1)
    (else (+ (fib-ref (- n 1)) (fib-ref (- n 2))))))

(define (even? n)
  (= (remainder n 2) 0))

(define (square x)
  (* x x))

;; Starting from
;;  a <- bq + aq + ap
;;  b <- bp + aq
;;
;; First transformation
;;  a_1 <- b0 q + a0 q + a0 p
;;  b_1 <- b0 p + a0 q
;;
;; Second transformation (b only)
;;  b_2 <- b1 p + a1 q
;;      <- (b0 p + a0 q)p + (b0 q + a0 q + a0 p)q
;;      <- b0(p^2 + q^2) + a0(2pq + q^2)
;;  <=> q' = (2pq + q^2)
;;      p' = (p^2 + q^2)
;;   [Easily checks against a2 = b0 q' + a0 q' + a0 p']


(define (q-prime p q)
  (+ (* 2 p q) (square q)))

(define (p-prime p q)
  (+ (square p) (square q)))

(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
  (cond ((= count 0) 
         b)
        ((even? count)
         (fib-iter a
                   b
                   (p-prime p q)  ;compute p'
                   (q-prime p q)  ;compute q'
                   (/ count 2)))
        (else 
         (fib-iter (+ (* b q) 
                      (* a q) 
                      (* a p))
                   (+ (* b p) 
                      (* a q))
                   p
                   q
                   (- count 1)))))

(map fib-ref '(1 2 3 4 5 6 7 8 9 10 11 12 13))
(map fib '(1 2 3 4 5 6 7 8 9 10 11 12 13))
