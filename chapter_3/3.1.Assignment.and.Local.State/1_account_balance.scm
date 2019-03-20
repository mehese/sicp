#lang sicp

(define (make-account balance)

  (define (withdraw amount)
    (if (>= balance amount)
        (begin
          (set! balance (- balance amount))
          balance)
        "Insufficient funds"))

  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request: MAKE-ACCOUNT" m))))

  dispatch)


(define acc1 (make-account (random 100)))
(define acc2 (make-account (random 100)))

((acc1 'deposit) 0)
((acc2 'deposit) 0)

((acc1 'withdraw) 5)
((acc2 'withdraw) 10)