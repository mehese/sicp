#lang sicp

(define (make-vect a b)
  (cons a b))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (add-vect v1 v2)
  (make-vect
   (+ (xcor-vect v1) (xcor-vect v2))
   (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect
   (- (xcor-vect v1) (xcor-vect v2))
   (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect
   (* s (xcor-vect v))
   (* s (xcor-vect v))))

(define a (make-vect 1 1))
(define b (make-vect -1 -1))
(define c (make-vect 2 2))
(define o (make-vect 0 0))

a ; ✔
b ; ✔
c ; ✔
o ; ✔

(display "Test operations") (newline)
(add-vect a b) ; = o ✔
(sub-vect a b) ; = c ✔
(sub-vect c (sub-vect a b)) ; = 0 ✔
(scale-vect 5 a) ; = {5 . 5} ✔
(scale-vect 10 c) ; = {20 . 20} ✔