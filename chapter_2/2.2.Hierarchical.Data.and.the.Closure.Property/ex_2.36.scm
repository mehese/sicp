#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs)) ; sum over first element of provided lists
            (accumulate-n op init (map cdr seqs))))) ; recurse passing the remainder of the lists

(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

(accumulate-n + 0 s)

(accumulate-n + 0 (list (list 1 1 1 1)
                        (list 1 2 2 3)
                        (list 1 3 4 5)
                        (list 1 4 8 7)
                        (list 1 5 16 9)))