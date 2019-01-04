#lang sicp


(define (square x)
  (* x x))

(define (next x)
  (if (= x 2) 3 (+ x 2)))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) 
         n)
        ((divides? test-divisor n) 
         test-divisor)
        (else (find-divisor 
               n 
               (next test-divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

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

(timed-prime-test 1000000007)
(timed-prime-test 1000000009)
(timed-prime-test 1000000021)

(timed-prime-test 10000000019)
(timed-prime-test 10000000033)
(timed-prime-test 10000000061)


(timed-prime-test 100000000003)
(timed-prime-test 100000000019)
(timed-prime-test 100000000057)

;    prime         √prime      t_old     t_new
;   1000000007   31622.776      2000      1000 
;   1000000009   31622.776      2000      1000
;   1000000021   31622.776      2001      1000
;
;  10000000019  100000.000      7000      4000
;  10000000033  100000.000      5999      3996
;  10000000061  100000.000      6002      4000
;
; 100000000003  316227.766     20004     13002
; 100000000019  316227.766     20002     12997
; 100000000057  316227.766     20000     12334
;
; -> ratios ~ 2, 3/2, 20/13
; -> certain operations are faster than others, good example that O(2N) ≡ O(N)