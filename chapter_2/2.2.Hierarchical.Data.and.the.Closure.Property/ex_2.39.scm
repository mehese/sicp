#lang sicp

(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (fold-right op 
                      initial 
                      (cdr sequence)))))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define (reverse sequence)
  (fold-right ;; dealing with lists
   (lambda (x y) (append y (list x))) nil sequence))

(define seq1 (list 1 2 3 4 5 6 7 8))
(define seq2 (list "a" "l" "u" "p" "i" "g" "u" "s"))

(reverse seq1)
(reverse seq2)

(define (reverse-2 sequence)
  (fold-left ;; dealing with elements
   (lambda (x y) (cons y x)) nil sequence))

(reverse-2 seq1)
(reverse-2 seq2)