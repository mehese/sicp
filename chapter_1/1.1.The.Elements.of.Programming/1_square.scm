#lang sicp

(define (square x) (* x x))

(define (sum-of-squares x y) (+ (square x) (square y)))

;;; random procedure that uses sum-of-squares
(define (f a)
  (sum-of-squares (+ a 1) (+ a 2)))

(write "Calling the square procedure ")

(square 2)

(square 21)

(square (+ 2 5))

(square (square (square 2)))

(write "Calling the sum of squares procedures ")

(sum-of-squares 5 4)

(write "Calling the f procedure ")

(f 5)