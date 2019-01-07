#lang sicp

(define (average a b)
  (/ (+ a b) 2))

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (display "Fixed point called")
  (newline)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (display (list guess next))
      (newline)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define f
  (lambda (x) (/ (log 1000) (log x))))

(define f-avg-damp
  (lambda (x) (/ (+ x (f x)) 2)))

(fixed-point f 4)

(fixed-point f-avg-damp 4)

;; Solution found: 4.55553
;;
;; No damping: 29 calls
;; Damping: 7 calls