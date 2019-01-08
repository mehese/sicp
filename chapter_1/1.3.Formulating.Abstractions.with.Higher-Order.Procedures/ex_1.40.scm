#lang sicp

(define square (lambda (x) (* x x)))

(define cube (lambda (x) (* x x x)))

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

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) 
            ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) 
               guess))


(define (cubic a b c)
  (lambda (x)
    (+
     (cube x)
     (* a (square x))
     (+ b x)
     c)))

(newtons-method cos 1.4)

((cubic 5 3 2) -4.2)

(newtons-method (cubic 5 3 -2) 1)

(newtons-method (cubic 3 0 2) 1)