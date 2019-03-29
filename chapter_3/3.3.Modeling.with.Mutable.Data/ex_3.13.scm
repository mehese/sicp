#lang sicp

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

;      +-------+      +-------+     +-------+
;z +-> | a | · |  +-> | b | · | +-> | c | · |
;      +-------+      +-------+     +-------+
;        ^                                |
;        |                                |
;        +--------------------------------+



z ; #0={a b c . #0#}, scheme can recognize looped lists, sweet!

; trying to evaluate last-pair it results in an endless loop, as
;  there's no cdr in the linked list that returns '()

; (last-pair z)

