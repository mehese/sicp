#lang sicp

(define (square x)
  (* x x))

;; Louis Reasoner's version
(define (expmod-lr base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (* (expmod-lr base (/ exp 2) m)
             (expmod-lr base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base 
             (expmod-lr base (- exp 1) m))
          m))))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base
            (expmod base (- exp 1) m))
          m))))

;; Let's test them out

(define t0 (runtime))
(expmod 2132903234455 3232452 23242)
(- (runtime) t0)

(define t1 (runtime))
(expmod-lr 2132903234455 3232452 23242)
(- (runtime) t1)

;; -> 3998 vs 344022 time units, so Louis's version is much slower
;; Explanation
;;  (define (f args) (...))
;; When calling
;;  (square (f random-args))
;;  f gets evaluated once
;;  depth call tree ~ log(N)
;; When calling
;;  (* (f random-args) (f random-args))
;;  f gets evaluated twice for each node:
;;  -> full binary tree depth O(log(2^N)) calls
;;  -> O(N*log(2)) = O(N) complexity

