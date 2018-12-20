#lang sicp

(define (cube x) (* x x x))

(define (p x)
  (display ".")
  (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

(sine 12.15)

;; 1. function p prints 5 dots => gets called 5 times

;; 2. Order of growth for function
;;  The function calls itself until angle < 0.01. It shrinks
;;  angle each time by 3. So the function will stop its steps calls
;;  when
;; 
;;  angle/(3^steps) = 0.01
;;  angle = 0.01*3^steps
;;  log(angle) = steps * log(0.01*3)
;;  steps ~ log(angle)
;;    => O(log(n))
;;  Space complexity is log(n) too as the procedure is not tail
;;  recursive optimized