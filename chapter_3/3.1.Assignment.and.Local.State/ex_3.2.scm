#lang sicp

(define (make-monitored fun)
  (let
      ((acc 0))

    (define (apply-fun arg)
      (set! acc (inc acc))
      (fun arg))
      

    (define (dispatch arg)
      (cond
        ((number? arg) (apply-fun arg))
        ((eq? 'how-many-calls? arg) acc)))

    dispatch))

    
(define s (make-monitored sqrt))

(s 100) ; ✔
    
(s 'how-many-calls?) ; ✔

(s 2) ; ✔

(s 'how-many-calls?) ; ✔

(s 'how-many-calls?) ; ✔

(s 25) ; ✔

(s 'how-many-calls?) ; ✔