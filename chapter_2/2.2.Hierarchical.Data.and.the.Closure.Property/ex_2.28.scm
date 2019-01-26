#lang sicp


;; Most likely there should be a prettier way of writing this
;; The trick is using append to bubble upwards the list merges
(define (fringe lst)
  (let
      ((head (car lst))
       (tail (cdr lst)))
    (if (null? tail)
       (if (list? head)
           (fringe head) ; if the head is a list, we need to recursively unpack it
           (list head)) ; returning a list otherwise the appends get messed up
       (if (list? head)
           (append (fringe head) (fringe tail)) ; we recurse on both the head and the tail
           (cons head (fringe tail)) ; prepend the head and recurse on tail
         ))))


;; All the test cases below
(define x 
  (list (list 1 2) (list 3 4)))
x
(fringe x) ; ✔
(newline)

(list x x)
(fringe (list x x)) ; ✔
(newline)

(define l2
  (list (list "a" "b" "c") (list (list 11 12) (list 21 22) 2)  (list "x" "y")))
l2
(fringe l2) ; ✔
(newline)

(define l3
  (list (list 1 (list 2 3) 4) (list (list 5 6) 7)))
l3
(fringe l3) ; ✔
(newline)

(define l4 (list 1 (list 2 3) 4))
l4
(fringe l4) ; ✔
(newline)