#lang sicp

;; Wanted to import this from an external file, but Racket is not being
;;  too friendly with that
(define (make-double-linked-list)

  (define contents (cons '() '()))

  (define ptr-tail (lambda () (cdr contents)))

  (define ptr-head (lambda () (car contents)))

  (define empty? (lambda () (null? (car contents))))

  (define (set-head! node)
    (set-car! contents node))

  (define (set-tail-ptr! node)
    (set-cdr! contents node))

  (define (make-node contents prev next)
    (cons (cons contents prev) next))

  (define (node-contents node)
    (caar node))
    
  (define (next node)
    (cdr node))

  (define (prev node)
    (cdr (car node)))

  (define (set-predecessor! node new-predecessor)
    (set-car! node (cons (node-contents node) new-predecessor)))

  (define (set-successor! node new-successor)
    (set-cdr! node new-successor))

  (define (generate-first-element contents)
    (let
        ((start-node (make-node contents nil nil)))
      (set-head! start-node)
      (set-tail-ptr! start-node)))    

  (define (append contents)
    (if (empty?)
        (begin
          (generate-first-element contents)
          (ptr-head))
        (let
            ((last (ptr-tail))
             (this (make-node contents nil nil)))
          ;; Make sure the last node will now point to the node we want to prepend
          (set-successor! last this)
          ;; Make sure this pointer marks the last node as its predecessor
          (set-predecessor! this last)
          ;; Don't forget to reset the end pointer for that sween O(1) running time!
          (set-tail-ptr! this)
          (ptr-head))))

  (define (pop-right)
    (if (empty?)
        (error "Boo! Trying to remove items from an already empty list!")
        (begin
          (let
              ((last (ptr-tail)))
            (let
                ((second-to-last (prev last)))
              (if (null? second-to-last)
                  ;; list will be empty again
                  (set! contents (cons '() '()))
                  ;; otherwise the second last element is now the tail
                  (begin
                    (set-successor! second-to-last nil)
                    (set-tail-ptr! second-to-last))))))))

  (define (pop-left)
    (if (empty?)
        (error "Boo! Trying to remove items from an already empty list!")
        (let
            ((second (next (ptr-head))))
          (if (null? second)
              ;; list will be empty again
              (set! contents (cons '() '()))
              ;; otherwise 2IC is now the leader
              (begin
                (set-predecessor! second nil)
                (set-head! second))))))

  (define (prepend contents)
    (if (empty?)
        (begin
          (generate-first-element contents)
          (ptr-head))
        (let
            ((first (ptr-head))
             (this (make-node contents nil nil)))
          (set-predecessor! first this)
          (set-successor! this first)
          (set-head! this)
          (ptr-head))))

  (define (print-list)
    (display "( ")
    (define (print-iter node)
      (if (null? node)
          (begin (display ")") (newline))
          (begin
            (display (node-contents node)) (display " ")
            (print-iter (next node)))))
    
    (print-iter (ptr-head)))

  (define (print-reverse)
    (display "( ")
    (define (print-iter node)
      (if (null? node)
          (begin (display ")") (newline))
          (begin
            (display (node-contents node)) (display " ")
            (print-iter (prev node)))))
                     
    (print-iter (ptr-tail)))

  (define (dispatch m)
    (cond
      ((eq? m 'print) (print-list))
      ((eq? m 'print-rev) (print-reverse))
      ((eq? m 'append) append)
      ((eq? m 'prepend) prepend)
      ((eq? m 'pop-left) (pop-left))
      ((eq? m 'pop-right) (pop-right))
      ((eq? m 'empty?) (empty?))
      ((eq? m 'head) (ptr-head))
      ((eq? m 'tail) (ptr-tail))
      (else (error "Unrecognized message" m))))

  dispatch)

(define (make-deque) (make-double-linked-list))
(define (print deque) (deque 'print))
(define (empty-deque? d) (d 'empty?))
(define (front-deque d) (d 'head))
(define (rear-deque d) (d 'tail))
(define (front-insert-deque d value) ((d 'prepend) value))
(define (rear-insert-deque d value) ((d 'append) value))
(define (front-delete-deque! d) (d 'pop-left))
(define (rear-delete-deque! d) (d 'pop-right))

(define d (make-deque))
(display (empty-deque? d)) (newline) ; ✔
(front-insert-deque d '3)
(front-insert-deque d '2)
(front-insert-deque d '1)
(print d) ; ✔
(rear-insert-deque d 'a)
(rear-insert-deque d 'b)
(rear-insert-deque d 'c)
(print d) ; ✔
(front-delete-deque! d)
(print d) ; ✔
(rear-delete-deque! d)
(print d) ; ✔
(display (empty-deque? d)) (newline) ; ✔
(rear-delete-deque! d)
(rear-delete-deque! d)
(rear-delete-deque! d)
(rear-delete-deque! d)
(display (empty-deque? d)) (newline) ; ✔