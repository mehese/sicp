#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define 
  (horner-eval x coefficient-sequence)
  (accumulate 
   (lambda (this-coeff higher-terms)
     (+ (* higher-terms x) this-coeff))
   0
   coefficient-sequence))

(define (lame-eval x lst)
  (define (lame-iter acc i lst)
    (if (null? lst)
        acc
        (lame-iter
         (+ acc (* (car lst) (expt x i)))
         (inc i)
         (cdr lst))))
  (lame-iter 0 0 lst))

(horner-eval 2 (list 1 3 0 5 0 1))

(lame-eval 2 (list 1 3 0 5 0 1))

(horner-eval 1.5 (list 3 1 4 1 5 9))

(lame-eval 1.5 (list 3 1 4 1 5 9))
