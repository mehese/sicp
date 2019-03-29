#lang sicp

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

;      +-------+      +-------+      +-------+
;x +-> | a | · |  +-> | b | · |  +-> | c | · | +-> '()
;      +-------+      +-------+      +-------+
(define three-pair-list (cons 'a (cons 'b (cons 'c '()))))
three-pair-list

(count-pairs three-pair-list) ; ✔


;              +---+---+
;  +---------->+ a | · | +-> '()
;  |           +---+---+
;+-+-+---+       ↑
;| · | · |       +---+
;+---+-+-+           |
;      |       +---+---+
;      +------>+ b | · |
;              +---+---+

(define a-pair (cons 'a nil))
(define b-pair (cons 'b nil))
(define returns-four (cons a-pair b-pair))
;; doesn't return 4 just yet!
(set-cdr! b-pair a-pair)

(count-pairs returns-four) ; ✔


;              +---+---+
;              | a | · | +-> '()
;              +---+---+
;+-+-+---+       ↑   ↑
;| · | · |       |   |
;+---+-+-+       |   |
;  |   |       +---+---+
;  +---+------>+ · | · |
;              +---+---+
(define x-pair (cons 'x nil))
(define y-pair (cons 'y nil))
(define returns-seven (cons y-pair y-pair))

(set-cdr! y-pair x-pair)
(set-car! y-pair x-pair)

(count-pairs returns-seven) ; ✔

;; Never returns
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

; +-------+     +-------+     +-------+
; | a | · | +-> | b | · | +-> | c | · |
; +-------+     +-------+     +-------+
;  ^                                |
;  |                                |
;  +--------------------------------+
(define causes-loop (make-cycle three-pair-list))

;(count-pairs causes-loop) ; ✔

; Conclusion:
;  count-pairs would work quite well for tree traversals, however with the ability
;  of re-setting the car and cdr of lists, lists of lists are no longer representations
;  of trees, but graphs that can contain cycles!