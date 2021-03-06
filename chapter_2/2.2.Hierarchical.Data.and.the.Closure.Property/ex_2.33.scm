#lang sicp

(define (square x)
  (* x x))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) 
              nil sequence))

(map square (list 1 2 3 4 5))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(append (list 1 2 3) (list "x" "y" "z"))

(define (length sequence)
  (accumulate (lambda (x y) (inc y)) 0 sequence))

(length (list 1 2 3 4 "fifth element"))
