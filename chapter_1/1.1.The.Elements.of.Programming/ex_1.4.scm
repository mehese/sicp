#lang sicp

(define (a-plus-abs-b a b)
  ((if (> b 0)
       +
       -) ; if b>0 then op=a+b else op=a-b (<=> a + abs(b))
   a
   b))

(= 6 (a-plus-abs-b 3 -3))
(= 6 (a-plus-abs-b 3 3))
(= 0 (a-plus-abs-b -3 -3))