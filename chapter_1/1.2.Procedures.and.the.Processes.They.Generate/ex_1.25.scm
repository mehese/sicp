#lang sicp

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

(define (expmod-new base exp m)
  (remainder (fast-expt base exp) m))

;; idea r(x*y % m) = r(x % m)*r(y % m)
;;  -> for an even e:
;;  ->  r(b^e % m) = r(b^(e/2) % m)*r(b^(e/2) % m)
;;  ->  r(b^e % m) = r(b^(e/2) % m)^2
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base (expmod base (- exp 1) m))
          m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) 
         (fast-prime? n (- times 1)))
        (else false)))

;; The new expmod works fine for an average sized prime

(fast-prime? 7297 20)

;; For a large number like the one below the new expmod runs
;;  out of memory
;(fast-prime? 17900683 5)

;; Below expmod-new runs 1000x slower than expmod (1007 vs 3614981)
(define t0 (runtime))
(expmod 17900683 1790062 1790062)
(display (- (runtime) t0))
(newline)
(define t1 (runtime))
(expmod-new 17900683 1790062 1790062)
(display (- (runtime) t1))
(newline)

;; Conclusion, Alyssa is wrong, the new procedure would be much slower.
;;  fast expt is quite slow for ultra large numbers. However using
;;  the hacked expmod we never deal with numbers much larger than m
;;  (see footnote 46 on Chapter 1) -- while using fast exp quickly results
;;  in ultra large integers that do not even fit in memory.