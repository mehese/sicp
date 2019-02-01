#lang sicp

(define (make-vect a b)
  (cons a b))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))


(define a (make-vect 1 1))
(define b (make-vect -1 -1))
(define c (make-vect 2 2))
(define o (make-vect 0 0))

;; Implementation

(let ((version "First version"))

  (display version) (newline)

  (define (make-frame origin edge1 edge2)
    (list origin edge1 edge2))

  (define (origin-frame frame) (car frame))

  (define (edge1-frame frame) (cadr frame))

  (define (edge2-frame frame) (caddr frame))

  (define f1 (make-frame o a b))

  (define f2 (make-frame a o c))

  (define f3 (make-frame a b c))

  (display f1) (newline)

  (display (origin-frame f1)) (newline)

  (display (edge1-frame f1)) (newline)

  (display (edge2-frame f1)) (newline)

  (display f2) (newline)

  (display (origin-frame f2)) (newline)

  (display (edge1-frame f2)) (newline)

  (display (edge2-frame f2)) (newline)


  (display f3) (newline)

  (display (origin-frame f3)) (newline)

  (display (edge1-frame f3)) (newline)

  (display (edge2-frame f3)) (newline))

(let ((version "Second version"))

  (display version) (newline)

  (define (make-frame origin edge1 edge2)
    (cons origin (cons edge1 edge2)))

  ;; this selector works just the same
  (define (origin-frame frame) (car frame))

  ;; this selector works just the same
  (define (edge1-frame frame) (cadr frame))

  ;; caddr would just return the x coordinate of edge2
  (define (edge2-frame frame) (cdr (cdr frame)))

  (define f1 (make-frame o a b))

  (define f2 (make-frame a o c))

  (define f3 (make-frame a b c))

  (display f1) (newline)

  (display (origin-frame f1)) (newline)

  (display (edge1-frame f1)) (newline)

  (display (edge2-frame f1)) (newline)

  (display f2) (newline)

  (display (origin-frame f2)) (newline)

  (display (edge1-frame f2)) (newline)

  (display (edge2-frame f2)) (newline)


  (display f3) (newline)

  (display (origin-frame f3)) (newline)

  (display (edge1-frame f3)) (newline)

  (display (edge2-frame f3)) (newline))