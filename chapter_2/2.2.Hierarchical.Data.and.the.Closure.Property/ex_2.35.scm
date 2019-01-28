#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append 
               (enumerate-tree (car tree))
               (enumerate-tree (cdr tree))))))


(define (count-leaves t)
  (accumulate
   + ; sum everything
   0
   (map
    (lambda (sub-tree) ; pop a 1 out for every leaf
         (if (pair? sub-tree)
             (count-leaves sub-tree)
             1))
        t)))

(define x (cons (list 1 2) (list 3 4)))

(count-leaves x)

(count-leaves (list x x))

(count-leaves (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))