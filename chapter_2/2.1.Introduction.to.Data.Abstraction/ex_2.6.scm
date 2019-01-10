#lang sicp

(define (inc x)
  (+ 1 x))

(define (square x)
  (* x x))


;; Returns a function that when passed any argument
;;  returns the function argument passed, i.e. returns the
;;  identity function. Turns every argument it's applied to
;;  to the identity function.
(define zero (lambda (f) (lambda (x) x)))
;;  ⬄ (define zero (lambda (f) identity))

;; Is a function than applies it's argument on f then applies it
;;  on x and then applies f on it again
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

; (add-1 zero)
; (g(n)=(lambda (f) (lambda (x) (f ((n f) x)))) zero)
; (lambda (f) (lambda (x) (f ((zero f) x))))
; (lambda (f) (lambda (x) (f (identity x)))
; (lambda (f) (lambda (x) (f x)))
(define one
   (lambda (f) (lambda (x) (f x)))) ; applies f once

; (add-1 one)
; (lambda (f) (lambda (x) (f ((one f) x))))
; (lambda (f) (lambda (x) (f (f x)))) 
(define two
  (lambda (f) (lambda (x) (f (f x))))) ; applies f twice

;; For the addition we can get inspired by the add one command
;; except of applying f once on (n f) we need to apply (m f) on (n f)
;; Note: using the + notation messes up the inc function above, so it's
;;  harder to check that the implementation is correct
(define (add n m)
  (lambda (f) (lambda (x) ((m f) ((n f) x)))))

(((add one two) inc) 0)

(display "Testing inc")
(newline)

((zero inc) 0)
((one inc) 0)
((two inc) 0)

((zero inc) 0)
(((add-1 zero) inc) 0)
(((add-1 (add-1 zero)) inc) 0)

(display "Testing square")
(newline)

((zero square) 2)
((one square) 2)
((two square) 2)

((zero square) 2)
(((add-1 zero) square) 2)
(((add-1 (add-1 zero)) square) 2)