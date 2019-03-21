#lang sicp

(define (make-account balance account-password)

  (define (call-the-cops)
    "7 incorrect passwords, calling cops")

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

  (define (pre-empt-dispatch)
    (let
        ((attempt-count 0))
      (lambda (pw m)
        (if (eq? pw account-password)
            (begin
              (set! attempt-count 0)
              (dispatch m))
            (begin
              (set! attempt-count (inc attempt-count))
              (if (> attempt-count 7)
                  (lambda (m) (call-the-cops))
                  (lambda (m) "Incorrect password")))))))

  (pre-empt-dispatch))


(define acc 
  (make-account 100 'secret-password))

((acc 'secret-password 'withdraw) 40); ✔

((acc 'some-other-password 'deposit) 50); ✔

((acc 'secret-password 'withdraw) 0); ✔

((acc 'some-other-password 'deposit) 50); 1
((acc 'some-other-password 'deposit) 50); 2
((acc 'some-other-password 'deposit) 50); 3
((acc 'some-other-password 'deposit) 50); 4
((acc 'some-other-password 'deposit) 50); 5
((acc 'some-other-password 'deposit) 50); 6
((acc 'some-other-password 'deposit) 50); 7
((acc 'some-other-password 'deposit) 50); ✔

(define acc2 
  (make-account 100 'secret-password))

((acc2 'some-other-password 'deposit) 1); 1
((acc2 'some-other-password 'deposit) 1); 2
((acc2 'some-other-password 'deposit) 1); 3
((acc2 'some-other-password 'deposit) 1); 4
((acc2 'some-other-password 'deposit) 1); 5
((acc2 'some-other-password 'deposit) 1); 6
((acc2 'some-other-password 'deposit) 1); 7
((acc2 'secret-password 'withdraw) 40); ✔
((acc2 'some-other-password 'deposit) 1); 1
((acc2 'some-other-password 'deposit) 1); 2
((acc2 'some-other-password 'deposit) 1); 3
((acc2 'some-other-password 'deposit) 1); 4
((acc2 'some-other-password 'deposit) 1); 5
((acc2 'some-other-password 'deposit) 1); 6
((acc2 'some-other-password 'deposit) 1); 7
((acc2 'some-other-password 'deposit) 1); ✔