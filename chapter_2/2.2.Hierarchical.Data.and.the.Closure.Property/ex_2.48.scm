#lang sicp

;; Imports
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

;; Implementation

(define (make-segment p1 p2)
  (list p1 p2))

(define (start-segment segm)
  (car segm))

(define (end-segment segm)
  (cadr segm))

(define (print-deets s)
  (display s) (newline)
  (display "Start: ") (display (start-segment s))
  (display " End: ") (display (end-segment s))
  (newline) (newline))  

(let
    ((s1 (make-segment a b))
     (s2 (make-segment o a))
     (s3 (make-segment b c))
     (s4 (make-segment o c)))
  (print-deets s1)  ; ✔
  (print-deets s2)  ; ✔
  (print-deets s3)  ; ✔
  (print-deets s4)) ; ✔