#lang sicp

;; Recursive version
(define (cont-frac-rec n d k)
  (define (iter i)
    (if (> i k)
        0 ; reached the depth limit
        (/ (n i) (+ (d i) (iter (+ i 1))))))  ; Ni/(Di + next fraction)
  (iter 1))


;; Retrieves 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8,
;;   if r((i + 1) % 3) = 0
;;     2*((i + 1)/3)
;;   else:
;;     1
(define (D i)
  (if
   (= 0 (remainder (+ i 1) 3))
   (* 2 (/ (+ i 1) 3))
   1))

(map D '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)) ; {1 2 1 1 4 1 1 6 1 1 8 1 1 10 1}

(+ 2.0
   (cont-frac-rec (lambda (i) 1) D 5)) ; ≈ 2.718 :)