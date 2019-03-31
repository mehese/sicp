#lang sicp

;Operation                 Resulting Queue
;(define q (make-queue))
;(insert-queue! q 'a)      a
;(insert-queue! q 'b)      a b
;(delete-queue! q)         b
;(insert-queue! q 'c)      b c
;(insert-queue! q 'd)      b c d
;(delete-queue! q)         c d

(define (make-queue)
 
  (let ((front-ptr '())
        (rear-ptr  '()))

    ;⟨definitions of internal procedures⟩    
    (define (set-front-ptr! item)
      (set! front-ptr item))
    
    (define (set-rear-ptr! item)
      (set! rear-ptr item))

    (define (empty-queue?)
      (null? front-ptr))

    (define (front-queue)
      (if (empty-queue?)
          (error "FRONT called with an empty queue" front-ptr)
          (car (front-ptr))))

    (define (insert-queue! item)
      (let ((new-pair (cons item '())))
        (cond ((empty-queue?)
               (set-front-ptr! new-pair)
               (set-rear-ptr! new-pair)
               front-ptr)
              (else
               (set-cdr! rear-ptr new-pair)
               (set-rear-ptr! new-pair)
               front-ptr))))

    (define (delete-queue!)
      (cond ((empty-queue?)
             (error "DELETE! called with an empty queue" front-ptr))
            (else
             (set-front-ptr! (cdr front-ptr))
             front-ptr)))
    
    (define (dispatch m)
      (cond
        ((eq? m 'empty-queue?) (empty-queue?))
        ((eq? m 'front-queue) (front-queue))
        ((eq? m 'insert) insert-queue!)
        ((eq? m 'delete) (delete-queue!))
        (else
         (error "Method not recognized"))))
        
    dispatch))


(define (empty-queue? q) (q 'empty-queue?))
(define (front-queue q) (q 'front-queue))

(define (insert-queue! q item) ((q 'insert) item))
(define (delete-queue! q) (q 'delete))

;; Test
(define q (make-queue))
(empty-queue? q)          ; #t ✔
(insert-queue! q 'a)      ; a ✔
(insert-queue! q 'b)      ; a b ✔
(delete-queue! q)         ; b ✔
(insert-queue! q 'c)      ; b c ✔
(define q2 (make-queue))
(insert-queue! q 'd)      ; b c d ✔
(empty-queue? q2)         ; #t ✔
(empty-queue? q)          ; #f ✔
(delete-queue! q)         ; c d ✔
(insert-queue! q2 '1)     ; 1 ✔
(insert-queue! q2 '2)     ; 1 2 ✔
(delete-queue! q)         ; d ✔
(delete-queue! q)         ; () ✔
(empty-queue? q)          ; #t ✔

