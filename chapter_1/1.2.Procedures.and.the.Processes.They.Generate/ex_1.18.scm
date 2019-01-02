#lang sicp

(define (double n)
  (+ n n))

(define (even? n)
  (= (remainder n 2) 0))

(define (halve n)
  (/ n 2)) ; only use for even n

;; This was easy and very much analogous to ex 1.16
;; Pseudocode:
;; res <- 0
;; while b > 0
;;   if b is even
;;      a <- 2*a
;;      b <- b/2
;;   else:
;;      res <- a+res
;;      b <- b-1
;; return res
(define (mul-iter a b res)
  (cond
    ((= b 0) res)
    ((even? b) (mul-iter (double a) (halve b) res))
    (else (mul-iter a (- b 1) (+ a res)))))

(define (mul a b)
  (mul-iter a b 0))


(list
 (list (* 2 4) (mul 2 4))
 (list (* 3 4) (mul 3 4))
 (list (* 3 3) (mul 3 3))
 (list (* 1 0) (mul 1 0))
 (list (* 1 1) (mul 1 1))
 (list (* 5 5) (mul 5 5)))