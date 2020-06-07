#lang sicp

(define compile-env '((y z) (a b c d e) (x y)))

(define (list-index elem lst)
  (define (iterate i lst)
    (cond
      ((null? lst) (error "Element not found in list"))
      ((eq? elem (car lst)) i)
      (else (iterate (+ i 1) (cdr lst)))))
  (iterate 0 lst))
        

(define (find-variable var compile-env)
  (define (iterate current-frame-index c-env)
    (cond
      ((null? c-env) 'not-found)
      ((member var (car c-env))
       ;; goes through the list twice when the element is in the list,
       ;;  so not the nicest way to go about it
       (list current-frame-index
             (list-index var (car c-env))))
      (else
       (iterate (+ current-frame-index 1) (cdr c-env)))))
  (iterate 0 compile-env))
      

(find-variable 
 'c '((y z) (a b c d e) (x y))) ;; (1 2) ✔

(find-variable 
 'x '((y z) (a b c d e) (x y))) ;; (2 0) ✔

(find-variable 
 'w '((y z) (a b c d e) (x y))) ;; not-found ✔ 