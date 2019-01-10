#lang sicp

(define (cons x y) 
  (lambda (m) (m x y)))

(define (car z) 
  (z (lambda (p q) p)))

;; (car (cons x y))
;; (car (lambda (m) (m x y))
;; ((lambda (m) (m x y))
;;  (lambda (p q) p))
;; ((lambda (p q) p) x y)
;; x QED

(define (cdr z) 
  (z (lambda (p q) q)))
;; (car (cons x y))
;; (car (lambda (m) (m x y))
;; ((lambda (m) (m x y))
;;  (lambda (p q) q))
;; ((lambda (p q) q) x y)
;; y QED

(define l (cons 2 3))
(car l)
(cdr l)