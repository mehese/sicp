#lang sicp

(define (square x)
  (* x x))

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

(define (passes-fermat? n)
  (define (iterate n a)
    (cond
      ((= a 0) #t)
      ((= (expmod a n n) a) (iterate n (- a 1)))
      (else #f))
    )
  (iterate n (- n 1)))

;; let's check known prime numbers
(display "Primes")
(newline)
(passes-fermat? 71471)
(passes-fermat? 57593)
(passes-fermat? 6373)
(passes-fermat? 38333)
(passes-fermat? 30491)
(passes-fermat? 5881)
(passes-fermat? 14029)
(passes-fermat? 24281)
(passes-fermat? 65761)
(passes-fermat? 31033)
(passes-fermat? 1217)

;; let's check known not prime numbers
(display "Not primes")
(newline)
(passes-fermat? 121)
(passes-fermat? 95582)
(passes-fermat? 96117)
(passes-fermat? 68756)
(passes-fermat? 38905)
(passes-fermat? 75080)
(passes-fermat? 72535)
(passes-fermat? 68653)
(passes-fermat? 77346)
(passes-fermat? 23960)

;; All good so far. Let's test the Carmichael's
(display "Carmichael numbers")
(newline)
(passes-fermat? 561)
(passes-fermat? 1105)
(passes-fermat? 1729)
(passes-fermat? 2465)
(passes-fermat? 2821)
(passes-fermat? 6601)

; yep, these numbes fool the Fermat test as expected. And they're not primes, so QED!
