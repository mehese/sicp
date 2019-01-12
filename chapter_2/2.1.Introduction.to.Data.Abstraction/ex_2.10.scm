#lang sicp

(define (make-interval a b) (cons a b))

(define (lower-bound interval)
  (car interval))

(define (upper-bound interval)
  (cdr interval))

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

(define (width interval)
  (/ (- (upper-bound interval) (lower-bound interval)) 2))

(define (div-interval x y)
  (if
   (= 0 (width y))
      (error "Width of the second interval is 0!")   
      (mul-interval x 
                (make-interval 
                 (/ 1.0 (upper-bound y)) 
                 (/ 1.0 (lower-bound y))))))

(let
    ((i1 (make-interval 2 3))
     (i2 (make-interval 5 5)))
  (display (div-interval i2 i1))
  (newline)
  (display (div-interval i1 i2))
  (newline))