#lang sicp

(define TOL 0.001)

(define (square x)
  (* x x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) TOL))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter2 guess x)
  (define new-guess (improve guess x))
  (if (close-enough new-guess guess)
      new-guess
      (sqrt-iter2 new-guess x)))

(define (close-enough x y)
  ;(display (cons x (cons y (abs (- (/ y x) 1)))))
  ;(newline)
  (<
   (abs (- (/ y x) 1))
   TOL))

(define (sqrt2 x)
  (sqrt-iter2 1.0 x))

(define lst '(1e-5 2. 3. 4. 1e4 43204350052177.98))
(map sqrt lst)
(map sqrt2 lst)

;; New procedure approximates small numbers better since the relative error is
;;  closer to the TOL factor. By considering the ratio of guesses as our convergence
;;  criterion, we can calculate the square root of really small or large numbers with
;;  the same relative error (barring floating point errors that is).
;; Old procedure approximates large numbers better, as the absolute value of guess
;;  and new guess is quite high, so their fraction converges even when the absolute
;;  error is higher.