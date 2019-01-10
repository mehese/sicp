#lang sicp

(define (make-point x y)
  (cons x y))

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (make-segment p1 p2)
  (cons p1 p2))

(define (start-segment segm)
  (car segm))

(define (end-segment segm)
  (cdr segm))

(define (div-point p constant)
  (make-segment (/ (x-point p) constant) (/ (y-point p) constant)))

(define (add-point p1 p2)
  (make-segment (+ (x-point p1) (x-point p2)) (+ (y-point p1) (y-point p2))))

(define (midpoint-segment segm)
  (div-point (add-point (start-segment segm) (end-segment segm)) 2))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(newline)
(display "Check 1")
(let
    ((a (make-point 0 0))
     (b (make-point 6 4)))
  (print-point a)
  (print-point b)
  (let
      ((s (make-segment a b)))
    (print-point (start-segment s))
    (print-point (end-segment s))
    (print-point (midpoint-segment s))))

(newline)
(display "Check 2")
(let
    ((a (make-point 5 5))
     (b (make-point 1 1)))
  (print-point a)
  (print-point b)
  (let
      ((s (make-segment a b)))
    (print-point (midpoint-segment s))))