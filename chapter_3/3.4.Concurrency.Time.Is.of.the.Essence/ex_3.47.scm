#lang sicp

(define (test-and-set! cell)
  (if (car cell)
      #t
      (begin (set-car! cell #t)
             #f)))

(define (clear! cell) (set-car! cell #f))

(define (make-mutex)
  (let ((cell (list #f)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
                 (the-mutex 'acquire))) ; retry
            ((eq? m 'release) (clear! cell))))
    the-mutex))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                  ;;
;;                           PART 1                                 ;;
;;                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-semaphore-with-mutex n)
  ;; Here a mutex protects incrementing and decrementing the number of
  ;;  available slots
  (let
      ((available-slots n)
       (safety (make-mutex)))
    (define (the-semaphore m)
      (cond
        ((eq? m 'acquire)
         (safety 'acquire)  ;; Acquire the lock before we read the slots
         (if (> available-slots 0) ;; so no process decrements the number
             (begin                ;; while we're doing it
               (set! available-slots (dec available-slots))
               (safety 'release))
             (begin
               (safety 'release)
               (the-semaphore 'acquire))))
        ((eq? m 'release)
         (safety 'acquire)
         (set! available-slots (inc available-slots))
         (safety 'release))
        (else
         (error "Message not understood" m))))
    the-semaphore))

(define s1 (make-semaphore-with-mutex 3))
(s1 'acquire)
(s1 'acquire)
(s1 'acquire)
(s1 'release)
(s1 'acquire); ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                  ;;
;;                           PART 2                                 ;;
;;                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-semaphore n)
  ;; Here atomic operations increment and decrement the quantity of
  ;;  available slots
  (define (test-and-set! available-slots)
    ;; **CAREFUL** this is assumed to be atomic
    (if (<= (car available-slots)  0)
        #t
        (begin
          (set-car! available-slots (dec (car available-slots)))
          #f)))

  (let
      ((available-slots (list n)))
    
    (define (the-semaphore m)
      (cond
        ((eq? m 'acquire)
         (if (test-and-set! available-slots)
             (the-semaphore 'acquire)))
        ((eq? m 'release)
         ;; **CAREFUL** this is assumed to be atomic
         (set-car! available-slots (inc (car available-slots))))))
    the-semaphore))

(define sem1 (make-semaphore 3))
(define sem2 (make-semaphore 2))
(sem1 'acquire)
(sem1 'acquire)
(sem1 'acquire)
(sem2 'acquire)
(sem2 'acquire)
(sem1 'release)
(sem1 'acquire)
(sem2 'release)
(sem2 'acquire); ✔