#lang sicp

(define (square x)
  (* x x))


(define (divides? a b)
  (= (remainder b a) 0))

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

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define NUM_TRIES 30)

(define (start-prime-test n start-time)
  (if (fast-prime? n NUM_TRIES)
      (report-prime (- (runtime) 
                       start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(timed-prime-test 13)

; 10000867, log: 16.11, t: 90
; 10000871, log: 16.11, t: 90
; 10000873, log: 16.11, t: 91
(timed-prime-test 10000867)
(timed-prime-test 10000871) 
(timed-prime-test 10000873)

; 100000217, log: 18.42, t: 102
; 100000223, log: 18.42, t: 104
; 100000231, log: 18.42, t: 105
(timed-prime-test 100000217)
(timed-prime-test 100000223)
(timed-prime-test 100000231)

; 1000000007, log: 20.72, t: 107  
; 1000000009, log: 20.72, t: 106
; 1000000021, log: 20.72, t: 105
(timed-prime-test 1000000007)
(timed-prime-test 1000000009)
(timed-prime-test 1000000021)

;; Not quite linear growth with log(n)
;;  mainly due to making repeated calls to
;;  fast-prime? even for low numbers.
