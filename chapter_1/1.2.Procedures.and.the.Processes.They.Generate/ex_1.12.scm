#lang sicp

;; Pascal's triangle
;; each elem is the sum of the two above it, sides = 0
;; 
;;         1
;;       1   1
;;     1   2   1
;;   1   3   3   1
;; 1   4   6   4   1


(define (slap-1 lst)
  (cons 1 (append lst '(1))))

(define (sum-first-2 lst)
  (+ (car lst) (cadr lst)))

(define (sum-pairs lst)
  (if (= 2 (length lst))
      (list (sum-first-2 lst))
      (cons (sum-first-2 lst) (sum-pairs (cdr lst)))))

(define (pascal-line lst)
  (slap-1 (sum-pairs lst)))

(define (pascal n)
  (cond
    ((= n 1) '(1))
    ((= n 2) '(1  1))
    ((> n 2) (pascal-line (pascal (- n 1))))))

(pascal 1)
(pascal 2)
(pascal 3)
(pascal 4)
(pascal 5)
(pascal 6)
(pascal 7)

