#lang sicp


;; Recursive version
(define (cont-frac-rec n d k)
  (define (iter i)
    (if (> i k)
        0 ; reached the depth limit
        (/ (n i) (+ (d i) (iter (+ i 1))))))  ; Ni/(Di + next fraction)
  (iter 1))

;; Iterative version -- the trick is build from i=k downwards
(define (cont-frac-iter n d k)
  (define (iter i acc)
    (if (= i 0)
        acc
        (iter (- i 1) (/ (n i) (+ (d i) acc))))); acc <- Ni/(Di + acc), i <- i - 1, 
  (iter k 0))



(display "Value to obtain")
(newline)
(/ 2 (+ 1 (sqrt 5)))

(display "Value obtained recursive")
(newline)
(cont-frac-rec (lambda (i) 1.0)
               (lambda (i) 1.0)
               11) ; becomes accurate at 4 decimal places at k=11

(display "Value obtained iterative")
(newline)
(cont-frac-iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                11) ; becomes accurate at 4 decimal places at k=11