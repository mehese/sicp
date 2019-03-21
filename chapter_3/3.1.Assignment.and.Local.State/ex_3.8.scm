#lang sicp

(define f
  (let ((prev 0)
        (curr 0))
    (lambda (arg)
      (begin
       (set! prev curr)
       (set! curr arg)
       prev))))
    

(+ (f 0) (f 1)) ; = 0 (i.e. Left to Right)

((lambda () (begin (f 0) (f 0) 'cleared-f)))

;; Left to Right Evaluation 
(let
    ((a (f 0))
     (b (f 1)))
  (+ a b)) ; = 0 ✔

;; Clear prev and curr
((lambda () (begin (f 0) (f 0) 'cleared-f)))

;; Right to Left Evaluation 
(let
    ((b (f 1))
     (a (f 0)))
  (+ a b)) ; = 1 ✔