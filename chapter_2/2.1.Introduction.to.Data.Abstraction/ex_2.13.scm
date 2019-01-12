#lang sicp

(define (make-interval a b) (cons a b))

(define (lower-bound interval)
  (car interval))

(define (upper-bound interval)
  (cdr interval))

(define (width interval)
  (/ (- (upper-bound interval) (lower-bound interval)) 2))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (tol i)
  (let
      ((c (center i))
       (l (lower-bound i))
       (h (upper-bound i)))
    (* (/ (abs (- c l)) c) 100.0)))

(define (make-center-percent c tol)
  (let
      ((w (/ (* tol c) 100)))
    (make-center-width c w)))

;; Old implementation
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) 
               (lower-bound y)))
        (p2 (* (lower-bound x) 
               (upper-bound y)))
        (p3 (* (upper-bound x) 
               (lower-bound y)))
        (p4 (* (upper-bound x) 
               (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

;; New implementation for approx multiplication
;; For positive numbers the product
;;   (a1, b1) x (a2, b2) = (a1a2, b1b2)
;; And:
;;   a1 = c1 - r1c1
;;   b1 = c1 + r1c1
;;   a2 = c2 - r2c2
;;   b2 = c2 + r2c2
;;  ⇒ a1a2 = c1c2(1 - r1 - r2 + r1r2)
;;    b1b2 = c1c2(1 + r1 + r2 + r1r2)
(define (mul-approx x y)
  (let
      ((c1 (center x))
       (r1 (/ (tol x) 100))
       (c2 (center y))
       (r2 (/ (tol y) 100)))
    (make-interval
     (* c1 c2 (+ 1 (- r1) (- r2) (+ (* r1 r2))))
     (* c1 c2 (+ 1 r1 r2 (* r1 r2))))))

;; Tolerance of product
;;   tol = (a - c)/c [* 100 if you want percentages]
;; For a product of strictly positive intervals
;;      c = (b - a)/2
;;        = (c1c2(1 + r1 + r2 + r1r2) - c1c2(1 - r1 - r2 + r1r2))/2
;;        = c1c2(1 + r1r2)
;;  (a-c) = c1c2(1 - r1 - r2 + r1r2) - c1c2(1 + r1r2)
;;  ⇒  r = (r1 + r2)/(1 + r1r2)
;;  For very small tolerances
;;    r1r2 ≃ 0
(define (tol-product x y)
  (let
      ((r1 (/ (tol x) 100))
       (r2 (/ (tol y) 100)))
    (* 100 (/ (+ r1 r2) (+ 1 (* r1 r2))))))

;; r1r2 ≃ 0
(define (tol-approx-product x y)
  (let
      ((r1 (/ (tol x) 100))
       (r2 (/ (tol y) 100)))
    (* 100 (+ r1 r2))))

(display "Compute the product and tolerance")
(newline)
(display "-------------------")
(newline)
(let
    ((i1 (make-center-percent  3.0 10.0))
     (i2 (make-center-percent 15.0  5.0))
     (i3 (make-center-percent 12.0  1.0))
     (i4 (make-center-percent  8.5  1.25))
     (i5 (make-center-percent  5.0  2.5))
     (i6 (make-center-percent 20.0  0.5)))
  (display (tol (mul-interval i1 i2)))
  (newline)
  (display (tol (mul-interval i2 i1)))
  (newline)
  (display (tol (mul-interval i1 i3)))
  (newline)
  (display (tol (mul-interval i5 i6)))
  (newline)
  (display (tol (mul-interval i3 i5)))
  (newline)
  (display (tol (mul-interval i6 i4)))
  (newline)
  (display (tol (mul-interval i2 i4)))
  (newline)
  (display (tol (mul-interval i5 i5)))
  (newline))

(newline)
(display "Compute tolerance of product directly")
(newline)
(display "----------")
(newline)
(let
    ((i1 (make-center-percent  3.0 10.0))
     (i2 (make-center-percent 15.0  5.0))
     (i3 (make-center-percent 12.0  1.0))
     (i4 (make-center-percent  8.5  1.25))
     (i5 (make-center-percent  5.0  2.5))
     (i6 (make-center-percent 20.0  0.5)))
  (display (tol-product i1 i2))
  (newline)
  (display (tol-product i2 i1))
  (newline)
  (display (tol-product i1 i3))
  (newline)
  (display (tol-product i5 i6))
  (newline)
  (display (tol-product i3 i5))
  (newline)
  (display (tol-product i6 i4))
  (newline)
  (display (tol-product i2 i4))
  (newline)
  (display (tol-product i5 i5))
  (newline))

(newline)
(display "Small intervals approx")
(newline)
(display "----------")
(newline)
(let
    ((i1 (make-center-percent  3.0 10.0))
     (i2 (make-center-percent 15.0  5.0))
     (i3 (make-center-percent 12.0  1.0))
     (i4 (make-center-percent  8.5  1.25))
     (i5 (make-center-percent  5.0  2.5))
     (i6 (make-center-percent 20.0  0.5)))
  (display (tol-approx-product i1 i2))
  (newline)
  (display (tol-approx-product i2 i1))
  (newline)
  (display (tol-approx-product i1 i3))
  (newline)
  (display (tol-approx-product i5 i6))
  (newline)
  (display (tol-approx-product i3 i5))
  (newline)
  (display (tol-approx-product i6 i4))
  (newline)
  (display (tol-approx-product i2 i4))
  (newline)
  (display (tol-approx-product i5 i5))
  (newline))