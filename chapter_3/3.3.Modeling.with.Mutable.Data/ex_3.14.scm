#lang sicp

;; The mystery function essentially reverses a linked list
(define (mystery x)
  (define (loop x y)
    (if (null? x)
        y
        (let ((temp (cdr x)))
          (set-cdr! x y)
          (loop temp x))))
  (loop x '()))

;;iter 1: (loop '(a b c d) '()
;;        temp <- '(b c d)
;;        x <- '(a)
;;        (loop '(b c d) '(a))
;;
;;iter 2: (loop '(b c d) '(a))
;;        temp <- '(c d)
;;        x <- '(b a)
;;        (loop '(c d) '(b a))
;;
;;iter 3: (loop '(c d) '(b a))
;;        temp <- '(d)
;;        x <- '(c b a)
;;        (loop '(d) '(c b a))
;;
;;iter 4: (loop '(d) '(c b a))
;;        temp <- '()
;;        x <- '(d c b a)
;;        (loop '() '(d c b a))
;;
;;iter 5: (loop '() '(d c b a))
;;        '(d c b a)
        
;      +---+---+      +---+---+     +---+---+      +---+---+
;v +-> | a | · |  +-> | b | · | +-> | c | · |  +-> | d | · | +-> '()
;      +---+---+      +---+---+     +---+---+      +---+---+

(define v (list 'a 'b 'c 'd))

(define w (mystery v))

;      +---+---+ 
;v +-> | a | · | +-> '()
;      +---+---+

v ; {a}


;      +---+---+      +---+---+     +---+---+      +---+---+
;w +-> | d | · |  +-> | c | · | +-> | b | · |  +-> | a | · | +-> '()
;      +---+---+      +---+---+     +---+---+      +---+---+
w ; {d c b a}