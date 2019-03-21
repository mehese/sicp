#lang sicp

(define (make-account balance account-password)

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

  (define (pre-empt-dispatch pw m)
    (if (eq? pw account-password)
        (dispatch m)
        (lambda (m) "Incorrect password")))

  pre-empt-dispatch)


(define acc 
  (make-account 100 'secret-password))

((acc 'secret-password 'withdraw) 40); ✔

((acc 'some-other-password 'deposit) 50); ✔

((acc 'secret-password 'withdraw) 0); ✔