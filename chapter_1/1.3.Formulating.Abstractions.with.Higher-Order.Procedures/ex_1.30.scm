#lang sicp

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (inc x)
  (+ x 1))

(define (even? n)
  (= 0 (remainder n 2)))

(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))

(define (integral-basic f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) ;; trapezoid rule
     dx))

(define (integral-simpson f a b n)
  (define h (/ (- b a) n))
  (define (simpson-term k)
    (*
     (if (even? k) 2 4) ; 2 if n is even else 4 if odd
     (f (+ a (* k h)))))
  (*
   (/ h  3.)
   (+
    (f a) ; y0
    (sum simpson-term 1 inc (- n 1)); y1 -> y{n-1}
    (f b)))); yn

(integral-basic cube 0 1 0.001)

(integral-simpson cube 0 1 100)
(integral-simpson cube 0 1 1000)

(integral-simpson square 0 1 100)
(integral-simpson identity 0 1 100)