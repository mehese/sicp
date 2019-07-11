#lang racket

;; https://www.rosettacode.org/wiki/Amb#Racket

(define failures null)
 
(define (fail)
  (if (pair? failures)
      ((first failures))
       (error "no more choices!")))
 
(define (amb/thunks choices)
  (let/cc k (set! failures (cons k failures)))
  (if (pair? choices)
    (let ([choice (first choices)]) (set! choices (rest choices)) (choice))
    (begin (set! failures (rest failures)) (fail))
    ))
 
(define-syntax-rule (amb E ...) (amb/thunks (list (lambda () E) ...)))
 
(define (assert condition) (unless condition (fail)))
(define (require condition) (unless condition (fail)))



;(with-handlers ([exn? (λ (exn) 'amb-died)])
;    (amb))

(provide amb)
(provide require)
(provide with-handlers)
(provide exn?)