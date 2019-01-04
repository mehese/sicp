#lang sicp

(define (square x)
  (* x x))

(define (non-trivial a n)
  ;; non-trivial:
  ;;   - (not equal to 1) OR (not equal to n-1)
  ;;   AND [a^2 = 1 % n] -- this is an ERROR in the book, as 1 % n = 1 for ALL n
  ;;   so we'll change the [a^2 = 1 % n] condition to [r(a^2 % m) = r(1 % n)]
  (define satisfies-conditions
    (and
     (not (= a 1))  ; not equal to 1
     (not (= a (- n 1))) ; not equal to n-1
     ; (= (square a) (modulo 1 n)))) ; commented out as it's wrong
     (= (remainder (square a) n) (remainder 1 n)))) ; is congruent to 1 % n
  (if satisfies-conditions (display (list a n)))
  (if satisfies-conditions (newline))
  
  satisfies-conditions)


(define (expmod base exp m)
  
  (define (tricky-function b e n)
    (define result (expmod b (/ e 2) n))
    (if (non-trivial result n)
        0
        (remainder (square result) n)))
  (cond ((= exp 0) 1)
        ((even? exp)
         (tricky-function base exp m))
        (else
         (remainder 
          (* base (expmod base (- exp 1) m))
          m))))

(define (passes-miller-rabin? n)
  (define (iterate n a)
    (define result (expmod a (- n 1) n))
    (cond
      ((= a 0) #t)
      ((= result 1) (iterate n (- a 1)))
      (else #f))
    )
  (iterate n (- n 1)))

(display "  Full test")
(newline)
(display "Primes")
(newline)
(map passes-miller-rabin? (list 71471 57593 6373))
(display "Non primes ")
(newline)
(map passes-miller-rabin? (list 121 75080 77346))
(display "Carmichael's")
(newline)
(map passes-miller-rabin? (list 561 1105 1729 2465 2821 6601))
;; Carmichael numbers do not fully pass the miller-rabin test

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 2 (random (- n 2)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((miller-rabin-test n) 
         (fast-prime? n (- times 1)))
        (else false)))

(newline)
(display "  Fast prime test")
(newline)

(define TIMES 1)
(define (test-fast-prime n)
  (fast-prime? n TIMES))

(display "Primes")
(newline)
(map test-fast-prime (list 71471 57593 6373))
(display "Non primes ")
(newline)
(map test-fast-prime (list 121 75080 77346))
(display "Carmichael's")
(newline)
(map test-fast-prime (list 561 1105 1729 2465 2821 6601))
;; Even at low TIMES checks, the Carmichael numbers fail the
;;  Miller-Rabin test, so we're good
