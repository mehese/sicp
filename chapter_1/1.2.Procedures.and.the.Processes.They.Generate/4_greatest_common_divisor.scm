#lang sicp

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(list
 (gcd 3 2)
 (gcd 40 6)
 (gcd 10 5)
 (gcd 6 9))
