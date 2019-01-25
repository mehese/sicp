#lang sicp

(define (for-each fun lst)
  (cond
    ((null? lst) #t)
    (else
     (let ;; sneakily call the function again while returning the function
         ((throw-me (for-each fun (cdr lst))))
       (fun (car lst))))))

(for-each 
 (lambda (x) (newline) (display x))
 (list 57 321 88))