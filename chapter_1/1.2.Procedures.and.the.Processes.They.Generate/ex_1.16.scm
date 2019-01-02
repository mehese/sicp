#lang sicp

(define (expt b n)
  (if (= n 0) 
      1 
      (* b (expt b (- n 1)))))

(define (square x)
  (* x x))

(define (even? n)
  (= (remainder n 2) 0))

;; I had to look up the solution here
;; http://www.billthelizard.com/2010/01/sicp-exercise-116-fast-exponentiation.html
;; The gist of the idea is that we make the transformation
;;   b <- b^2
;;   n <- n/2
;; for as long as we can (i.e. n/2 remains even), while keeping a the same. This preserves
;; the requirement that a*b^n is a constant. As soon as n/2 stops being even, the result is
;; "passed" to a
;;   a <- b*a
;;   n <- n-1
;; In pseudocode this would return
;;
;; f_iter(b, n):
;;  a <- 1
;;  while n > 0
;;   if n even:
;;     b <- b^2
;;     n <- n/2
;;   if n odd:
;;     a <- b*a
;;     n <- n-1
;;  return a

(define (new-expt b n)
  (define (expt-iter base exponent a)
    (cond
      ; this also helps in the b^0 case
      ((= exponent 0) a)
      ; if the exponent is even we can call expt-iter(b^2, n/2, a)
      ((even? exponent) (expt-iter (square base) (/ exponent 2) a))
      ; a gets incremented every time whe can't square. The function
      ; always reaches this last step when n =/= 0
      (else  (expt-iter base (- exponent 1) (* base a)))))

  (expt-iter b n 1))


(list
 (list(expt 9999 0) (new-expt 9999 0))
 (list(expt 2 5) (new-expt 2 5))
 (list(expt 3 5) (new-expt 3 5))
 (list(expt 12 4) (new-expt 12 4))
 (list(expt 5 6) (new-expt 5 6))
 (list(expt 2 7) (new-expt 2 7))
 (list(expt 3 8) (new-expt 3 8)))