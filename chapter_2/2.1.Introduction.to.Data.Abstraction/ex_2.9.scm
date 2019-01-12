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

(define (sub-interval x y)
  (add-interval x
                (make-interval
                 (- (upper-bound y))
                 (- (lower-bound y)))))

(define (width interval)
  (/ (- (upper-bound interval) (lower-bound interval)) 2))

;; Width of the sum
;;  2 pairs (a1, b1), (a2, b2)
;;  w1 = (b1 - a1)/2, w2 = (b2 - a2)/2
;;  Sum:
;;   (a1, b1) + (a2, b2) = (a1 + a2, b1 + b2)
;;  Width sum:
;;   w_sum = ½((b1 + b2) - (a1 + a2))
;;         = ½(b1 - a1) +  ½(b2 - a2)
;;         = w1 + w2 QED
;;
;; Width of the difference
;;  Sum:
;;   (a1, b1) - (a2, b2) = (a1 + (-b2), b1 + (-a2))
;;                       = (a1 - b2, b1 - a2)
;;  Width sum:
;;   w_sum = ½((b1 - a2) - (a1 - b2))
;;         = ½((b1 - a1) + (b2 - a2))
;;         = w1 + w2 QED

(newline)
(display "Sum/Sub sequences are identical")
(newline)
(display "-------------------------------")
(newline)
(let
    ((i1 (make-interval 4 6)) ; w 2/2
     (i2 (make-interval 3 11))) ; w 8/2
  (display (width (add-interval i1 i2)))
  (display ", ")
  (display (width (add-interval i2 i1)))
  (display ", ")
  (display (width (sub-interval i1 i2)))
  (display ", ")
  (display (width (sub-interval i2 i1))))

(display " = ")
(let
    ((i1 (make-interval -1 1)) ; w 2/2
     (i2 (make-interval -2 6))) ; w 8/2
  (display (width (add-interval i1 i2)))
  (display ", ")
    (display (width (add-interval i2 i1)))
  (display ", ")
  (display (width (sub-interval i1 i2)))
  (display ", ")
  (display (width (sub-interval i2 i1)))
  (newline))

(newline)
(display "Product/Div sequences are not identical")
(newline)
(display "---------------------------------------")
(newline)
(let
    ((i1 (make-interval -1 1)) ; w 2/2
     (i2 (make-interval -2 6))) ; w 8/2
  (display (width (mul-interval i1 i2)))
  (display ", ")
  (display (width (div-interval i1 i2)))
  (display ", ")
  (display (width (div-interval i2 i1))))
(display " =/= ")
(let
    ((i1 (make-interval 4 6)) ; w 2/2
     (i2 (make-interval 3 11))) ; w 8/2
  (display (width (mul-interval i1 i2)))
  (display ", ")
  (display (width (div-interval i1 i2)))
  (display ", ")
  (display (width (div-interval i2 i1)))
  (newline))