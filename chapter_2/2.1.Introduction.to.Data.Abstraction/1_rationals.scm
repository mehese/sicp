#lang sicp

;; Prerequisites
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))


;; Definitions
(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) 
          (/ d g)))) ; {(/ n g) . (/ d g)}

(define (numer x)
  (car x)) ; {n . d} -> n

(define (denom x)
  (cdr x)) ; {n . d} ->  d

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))


;; Testing
(define a (make-rat 5 4))
(define b (make-rat 4 3))

(equal-rat? a b)
(print-rat a)
(print-rat b)
(print-rat (add-rat a b))
(print-rat (sub-rat a b))
(print-rat (mul-rat a b))