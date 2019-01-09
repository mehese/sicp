#lang sicp

(define square (lambda (x) (* x x)))

(define cube (lambda (x) (* x x x)))

(define (average a b) (/ (+ a b) 2))

(define (improve guess x)
  (average guess (/ x guess)))

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

(define (close-enough? v1 v2)
  (< (abs (- v1 v2)) tolerance))

(define (fixed-point f first-guess)
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

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (sqrt-old x)
  (sqrt-iter 1.0 x))

;; takes two procedures as arguments:
;;    - a method for telling whether a guess is good enough
;;    - a method for improving a guess
(define (iterative-improve good-enough? improve-guess)
  ;; should return as its value a procedure that takes a guess as argument
  (define (ff guess)
    ;; keeps improving the guess until it is good enough
    (if (good-enough? guess)
        guess
        (ff (improve-guess  guess))))
  ff)

;; Rewrite sqrt with iterative-improve
(define (sqrt-new x)
  ((iterative-improve
    (lambda (g) (good-enough? g x))
    (lambda (g) (improve g x)))
   1.0))

(display "Testing sqrt with iterative improve")
(newline)
(sqrt-new 2) ; = 1.41 ✔
(sqrt-new (expt 2 2)) ; = 2.00 ✔
(sqrt-new 9) ; = 3.00 ✔
(sqrt-new (expt 12324 2)) ; = 12324.00 ✔

;; Rewrite fixed point with iterative-improve
(define (fixed-point-new f first-guess)
  ((
    iterative-improve
    (lambda (x) (close-enough? x (f x)))
    f
    )
   first-guess))


;; Functions to test fixed point new on
(define (cube-root x)
  (fixed-point-new (average-damp  (mapping x 2)) 1.0))

(define (nth-root x n)
  (define (damp-growth-fun n) (round (/ (log n) (log 2))))
  (let
      ((num-damps (damp-growth-fun n))) 
    (fixed-point-new
     ((repeated average-damp num-damps) (mapping x (- n 1)))
     1.0)))

(display "Testing cube root with iterative improve")
(newline)
(cube-root 27) ; = 3.00 ✔
(cube-root (expt 5 3)) ; = 5.00 ✔
(nth-root (expt 3 4) 4) ; = 3.00 ✔
(nth-root (expt 2 20) 20) ; = 2.00 ✔
(nth-root (expt 5 30) 30) ; = 5.00 ✔
(nth-root (expt 1.5 40) 40) ; = 1.50 ✔