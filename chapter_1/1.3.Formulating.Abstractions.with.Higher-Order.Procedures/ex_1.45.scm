#lang sicp

(define square (lambda (x) (* x x)))

(define cube (lambda (x) (* x x x)))

(define (average a b) (/ (+ a b) 2))

(define (average-damp f)
  (lambda (x) 
    (average x (f x))))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (define (iter acc i)
    (if (= i n)
        acc
        (iter (compose f acc) (+ i 1))))
  (iter f 1))

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define dx 0.00001)

(define (mapping x power)
  (lambda (y)
    (/ x (expt y power))))

(define (sqrt x)
  (fixed-point 
   (average-damp  (mapping x 1))
   1.0))

(define (cube-root x)
  (fixed-point 
   (average-damp (mapping x 2))
   1.0))

(define (fourth-root x)
  (fixed-point 
   ((repeated average-damp 2) (mapping x 3)); not repeating the average damping -> no convergence
   1.0))

(define (damp-growth-fun n)
  ;(round (sqrt n))) ; sqrt converges, cube root doesnt, so log?
  (round (/ (log n) (log 2)))) ; log_2(n) works nicely up to power 40

(define (nth-root x n)
  (let
      ((num-damps (damp-growth-fun n))) 
    (fixed-point
     ((repeated average-damp num-damps) (mapping x (- n 1)))
     1.0)))


(sqrt 2)
(nth-root 2 2)
(cube-root (expt 2 3))
(nth-root (expt 2 3) 3)
(fourth-root (expt 3 4))
(nth-root (expt 3 4) 4) ; = 3.00 ✔
(nth-root (expt 3 20) 20) ; = 3.00 ✔
(nth-root (expt 5 30) 30) ; = 5.00 ✔
(nth-root (expt 1.5 40) 40) ; = 1.50 ✔