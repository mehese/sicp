#lang sicp

;; f(n) = n if n < 3
;;      = f(n-1) + 2f(n-2) + 3f(n-3)

(define (f-rec n)
  (if (< n 3)
      n
      (+
       (f-rec (- n 1))
       (* 2 (f-rec (- n 2)))
       (* 3 (f-rec (- n 3))))))

(define (f n)
  (define (eval-fun a b c)
    (+ a (* 2 b) (* 3 c)))
  (define (f-iter a b c cnt acc)
    (if (= cnt n)
        (eval-fun a b c)
        (f-iter (eval-fun a b c) a b)))
  (if (< n 3)
      n
      (f-iter 2 1 0 3 0)))

(define lst '(1 2 3 4 5 6 7 8 9 10 11 20))
(map f-rec lst)
(map f-rec lst)
