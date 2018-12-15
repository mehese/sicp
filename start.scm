#lang sicp

(define factorial (lambda (n)
                    (if (= n 0)
                        1
                        (* n (factorial (- n 1))))))
             

(define lst (map factorial '(1 2)))

(display lst)