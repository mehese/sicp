#lang sicp

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

;      +-------+      +-------+
;x +-> | a | · |  +-> | b | · | +-> '()
;      +-------+      +-------+
(define x (list 'a 'b))
;      +-------+      +-------+
;y +-> | c | · |  +-> | d | · | +-> '()
;      +-------+      +-------+
(define y (list 'c 'd))
;      +-------+      +-------+     +-------+      +-------+
;z +-> | a | · |  +-> | b | · | +-> | c | · |  +-> | d | · | +-> '()
;      +-------+      +-------+     +-------+      +-------+
(define z (append x y))

z ; {a b c d}

(cdr x) ; {b}
;            +-------+      +-------+
;w +-> x +-> | a | · |  +-> | b | · | +-> y
;            +-------+      +-------+
(define w (append! x y))
; the cdr of the last pair of x is no longer '() (aka nil), but y.

w ; {a b c d}

(cdr x) ; {b c d}