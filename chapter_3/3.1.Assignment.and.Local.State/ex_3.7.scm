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

(define (make-joint orig-acc orig-password new-password)
  (define (alias-dispatch pw message)
    (if (eq? pw new-password)
        (orig-acc orig-password message)
        (lambda (m) "Incorrect password!")))
  alias-dispatch)


(define peter-acc 
  (make-account 100 'open-sesame))

(define paul-acc
  (make-joint peter-acc 'open-sesame 'rosebud))

((peter-acc 'open-sesame 'withdraw) 40)
((peter-acc 'open-sesame 'deposit) 0) ; balance = 60 ✔
((paul-acc 'rosebud 'deposit) 1) ; balance = 61 ✔
((peter-acc 'open-sesame 'deposit) 0) ; balance = 61 ✔