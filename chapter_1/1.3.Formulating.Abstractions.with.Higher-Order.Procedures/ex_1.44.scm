#lang sicp

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (define (iter acc i)
    (if (= i n)
        acc
        (iter (compose f acc) (+ i 1))))
  (iter f 1))

(define dx 0.00001)

(define (smooth f)
  (lambda (x)
    (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

((smooth inc) 0.)
((smooth sin) 3.1415)
((smooth cos) 3.1415)

;; *careful* repeat the smooth function n times and apply on f
;;  don't return (repeated (smooth f) n)
(define (n-fold-smooth f n)
  ((repeated smooth n) f)) 


((n-fold-smooth inc 3) 0.0)
((n-fold-smooth sin 5) 3.1415)
((n-fold-smooth cos 6) 3.1415) ; works as expected