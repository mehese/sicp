#lang sicp

;; Ackermann's function
;; https://en.wikipedia.org/wiki/Ackermann_function
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

(A 1 10)
(A 2 4)
(A 3 3)

(write "f(n)")
(newline)
(define (f n) (A 0 n))
; computes 2 n
(f 1) ; 2
(f 2) ; 4
(f 3) ; 6
(f 100) ; 200

(write "g(n)")
(newline)
(define (g n) (A 1 n))
; A(1, n) = 0 if n = 0
;         = 2 if n = 1
;         = A(0, A(1, n - 1)) otherwise
;           <=> f(A(1, n - 1))
;           <=> f(g(n-1))
;           <=> 2g(n-1)
; => g(n) = 2^n for n > 0
(g 0) ; 0
(g 1) ; 2
(g 2) ; 4
(g 3) ; 8
(g 8) ; 256
(g 10) ; 1024

(write "h(n)")
(newline)
(define (h n) (A 2 n))
; A(2, n) = 0 if n = 0
;         = 2 if n = 1
;         = A(1, A(2, n - 1)) otherwise
;           <=> g(h(n-1)) <=> 2^h(n-1)
; => h(n) = 2↑↑n, (cf https://en.wikipedia.org/wiki/Knuth%27s_up-arrow_notation)
(h 0) ; 0
(h 1) ; 2
(h 2) ; 4
(h 4) ; 65536 (h(5) is already a bit too big)

(write "k(n)")
(newline)
(define (k n) (* 5 n n))
;; computes 5n^2
(k 1) ; 5
(k 2) ; 20
(k 5) ; 125