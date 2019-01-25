#lang sicp

(cons 2 nil)

(define (make-list n)
  (define (list-iter i)
    (if (= i n)
        (cons n nil)
        (cons i (list-iter (inc i)))))

  (cons 0 (list-iter 1)))

(make-list 10)

(define one-through-four (list 1 2 3 4))

one-through-four
(car one-through-four)
(car (cdr one-through-four))
(car (cdr (cdr one-through-four)))
(car (cdr (cdr (cdr one-through-four))))
(cons 99 one-through-four)

(display "Search list by index")(newline)


(define (list-ref lst i)
  (if (= i 0)
      (car lst)
      (list-ref (cdr lst) (dec i))))

(define lett-list (list "a" "b" "c" "d" "e"))

(list-ref lett-list 0)
(list-ref lett-list 3)
(list-ref lett-list 4)

(display "Measure list length")(newline)


(define (length-rec lst)
  (if (null? lst)
      0
      (+ 1 (length-rec (cdr lst)))))

(length-rec one-through-four)
(length-rec lett-list)
(length-rec (list))

(display "----------------")(newline)

(define (length lst)
  (define (length-iter acc lst)
    (if (null? lst)
        acc
        (length-iter (inc acc) (cdr lst))))
  (length-iter 0 lst))

(length one-through-four)
(length lett-list)
(length (list))

(display "Concatenate two lists")(newline)

(define (concatenate list-1 list-2)
  (if (null? list-1)
      list-2
      (cons (car list-1) (concatenate (cdr list-1) list-2))))

(concatenate (list 1 2 3) (list "a" "b" "c"))
(concatenate (list "a" "b" "c") (list 1 2 3))