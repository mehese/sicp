#lang sicp

;; Prerequisites
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))


;; New make-🐀
(define (make-rat n d)
  (let ((g (gcd (abs n) (abs d))))
    (cond
      ((and (> n 0) (< d 0))
       (cons (/ (- n) g) (/ (- d) g))) ; 2/-3 -> -2/3
      ((and (< n 0) (< d 0))
       (cons (/ (- n) g) (/ (- d) g))) ; =2/-3 -> 2/3     
      (else
       (cons (/ n g) (/ d g)))))) ; {(/ n g) . (/ d g)}

;; Definitions
(define (numer x)
  (car x)) ; {n . d} -> n

(define (denom x)
  (cdr x)) ; {n . d} ->  d

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(print-rat (make-rat 2 3))
(print-rat (make-rat 4 6))


(print-rat (make-rat -5 4))
(print-rat (make-rat -10 8))

(print-rat (make-rat 1 -2))
(print-rat (make-rat 10 -20))

(print-rat (make-rat -3 -2))
(print-rat (make-rat -15 -10))