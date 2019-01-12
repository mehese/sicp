#lang sicp

(define (make-interval a b) (cons a b))

(define (lower-bound interval)
  (car interval))

(define (upper-bound interval)
  (cdr interval))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) 
                    (lower-bound y))
                 (+ (upper-bound x) 
                    (upper-bound y))))

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

(define (div-interval x y)
  (mul-interval x 
                (make-interval 
                 (/ 1.0 (upper-bound y)) 
                 (/ 1.0 (lower-bound y)))))

(define (sub-interval x y) ; Safest bet is to build it on div-interval
  (add-interval x
                (make-interval
                 (- (upper-bound y))
                 (- (lower-bound y)))))

(let
    ((i1 (make-interval 5 7))
     (i2 (make-interval 2 4)))
  (display (add-interval i1 i2))
  (newline)
  (display (sub-interval i1 i2))
  (newline))

(let
    ((i1 (make-interval 4 6))
     (i2 (make-interval 3 10)))
  (display (add-interval i1 i2))
  (newline)
  (display (sub-interval i1 i2))
  (newline))
