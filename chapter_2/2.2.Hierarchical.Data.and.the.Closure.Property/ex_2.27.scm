#lang sicp

(define (last-pair lst)
  (if (null? (cdr lst))
      lst
      (last-pair (cdr lst))))

(define (reverse lst)
  (if (null? (cdr lst))
      (last-pair lst)
      (append (reverse (cdr lst)) (cons (car lst) nil))))

(define x 
  (list (list 1 2) (list 3 4)))

x

(reverse x)

(define (deep-reverse lst)
  (let
      ((head (car lst))
       (tail (cdr lst)))
    ;(display head) (display tail) (newline)
    (cond
      ((and (pair? head) (not (null? tail)))
       (append (deep-reverse tail) (cons (deep-reverse head) nil)))
      ((and (not (pair? head)) (not (null? tail)))
       (append (deep-reverse tail) (cons head nil)))
      ((and (not (pair? head)) (null? tail))
       (list head))
      ((and (pair? head) (null? tail))
       (list (deep-reverse head))))))
x
(deep-reverse x)

(define l2
  (list (list "a" "b" "c") (list (list 1 1) (list 1 2) 2)  (list "x" "y")))

l2

(deep-reverse l2)

