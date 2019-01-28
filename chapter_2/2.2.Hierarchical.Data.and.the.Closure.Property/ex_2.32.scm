#lang sicp

(define (subsets s)
  ;; The function assumes that it's being passed a set
  (if (null? s)
      (list nil) ;; when given just one element we need to append the empty list
      (let ((rest (subsets (cdr s))))
        ;; append bubbles up a one list structure rather than a nested one
        ;; the set of all sets is
        ;;  - the set of all subsets excluding the first number
        ;;  - the set of all subsets excluding the first number with the first number inserted
        (append rest (map ( ;; concatenate the first element of the list 
                           lambda (x) (cons (car s) x)
                           ) rest)))))
(subsets (list 1 2 3))