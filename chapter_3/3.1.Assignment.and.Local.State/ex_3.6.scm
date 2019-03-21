#lang sicp

(#%require (only racket/base random-seed))

(define (rand-update k)
  ;; Hacked equivalent of rand update
  (random-seed k)
  (random 100))

(define (rand-function)
  (define value 0)
  
  (define (generate)
      
    (set! value (rand-update value))
    value)

  (define (reset new-value)
    (set! value new-value)
    value)

  (define (dispatch m)
    (cond
      ((eq? m 'generate) (generate))
      ((eq? m 'reset) reset)
      (else (error "Unrecognized message"))))

  dispatch)

(define rand (rand-function))

((rand 'reset) 5)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate); ✔
(display "--") (newline)
((rand 'reset) 5)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate); ✔