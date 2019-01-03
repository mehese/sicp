#lang sicp

(define (gcd a b)
  (display (list a b))
  (newline)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(gcd 206 40)

;; Normal order (fully expand then reduce)
;; gcd(206, 40)
;; 40 = 0?
;;   (...)
;;   gcd(40, r(0r, 0r)) -> 0, 1r
;; 1r = 0? <- 1 eval, res=6
;;   (...)
;;   gcd(1r, r(0, 1r) -> 1r, 2r
;; 2r = 0? <- 2 eval, res=4
;;   (...)
;;   gcd(2r, r(1r, 2r), -> 2r, 4r
;; 4r = 0? <- 4 eval, res=2
;;   (...)
;;   gcd(4r, r(2r, 4r)) -> 4r, 7r
;; 7r = 0? <- 7 evaluations, res=0
;;   4r <- 4 eval
;;
;;    -> 1 + 2 + 4 + 7 + 4 = 18 evaluations

;; Applicative order (fully expand then reduce)
;; gcd(206, 40)
;; 40 = 0?
;;   (...)
;;   gcd(40, r(206, 40)) -> 1 eval
;; 6 = 0?
;;   (...)
;;   gcd(6, r(40, 6)) -> 1 eval
;; 4 = 0?
;;   (...)
;;   gcd(2, r(6, 4)) -> 1 eval
;; 2 = 0?
;;   gcd(2, r(4, 0) -> 1 eval
;; 0 = 0?
;;   2
;;
;;   -> 1 + 1 + 1 + 1 = 4 evaluations