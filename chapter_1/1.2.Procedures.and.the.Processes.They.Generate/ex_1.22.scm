#lang sicp

(define (square x)
  (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) 
         n)
        ((divides? test-divisor n) 
         test-divisor)
        (else (find-divisor 
               n 
               (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

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

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) 
                       start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))


;; sanity check time for a large prime
;(timed-prime-test 100000027837)
;(newline)

(define (search-for-primes num-over num-primes)
  (cond
    ((= num-primes 0) (display "Done"))
    ((prime? num-over)
     (display "Found a prime ")
     (timed-prime-test num-over)
     (newline)
     (search-for-primes (+ num-over 1) (- num-primes 1)))
    (else (search-for-primes (+ num-over 1) num-primes))))

;; The search below shows all times as 0, so doesn't help
(search-for-primes 1000 3)
(newline)
(search-for-primes 100000 3)
(newline)
(search-for-primes 1000000 3)
(newline)

;; Let's try bigger numbers, give it some time to think
(search-for-primes 1000000000 3) ; 1e9
(newline)
(search-for-primes 10000000000 3) ; 1e10
(newline)
(search-for-primes 100000000000 3) ; 1e11
(newline)

; 1000000007   (sqrt:  31622.776) *** 2000 
; 1000000009   (sqrt:  31622.776) *** 2000
; 1000000021   (sqrt:  31622.776) *** 2001
;
; 10000000019  (sqrt: 100000.000) *** 7000
; 10000000033  (sqrt: 100000.000) *** 5999
; 10000000061  (sqrt: 100000.000) *** 6002
;
; 100000000003 (sqrt: 316227.766)*** 20004
; 100000000019 (sqrt: 316227.766)*** 20002
; 100000000057 (sqrt: 316227.766)*** 20000
;; scales *mostly* linearly with √n