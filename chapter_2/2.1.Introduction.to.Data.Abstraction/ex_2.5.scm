#lang sicp

(define (cons a b)
  (* (expt 2 a) (expt 3 b))) ; as defined by the problem

(define (car number)
  (define (iter acc)
    (if (= 0 (remainder  number (expt 2 acc)))
        (iter (+ 1 acc))
        (- acc 1)))
     
  (iter 1))

(define (cdr number)
  (define (iter acc)
    (if (= 0 (remainder  number (expt 3 acc)))
        (iter (+ 1 acc))
        (- acc 1)))
     
  (iter 1))

(let
    ((l (cons 5 3)))
  (display (car l))
  (display ", ")
  (display (cdr l))
  (newline))

(let
    ((l (cons 233 311)))
  (display (car l))
  (display ", ")
  (display (cdr l))
  (newline))

(let
    ((l (cons 0 1)))
  (display (car l))
  (display ", ")
  (display (cdr l))
  (newline))
