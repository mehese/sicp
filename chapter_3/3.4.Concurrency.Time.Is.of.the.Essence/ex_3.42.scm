(define (parallel-execute . fun-list)
  (map (lambda (x) (x)) fun-list))

(define (make-serializer)
  (lambda (x) x))

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

  (let ((protected (make-serializer)))
    (let ((protected-withdraw (protected withdraw))
          (protected-deposit (protected deposit)))

      (define (dispatch m)
        (cond 
          ((eq? m 'withdraw) protected-withdraw)
          ((eq? m 'deposit) protected-deposit)
          ((eq? m 'balance) balance)
          (else (error "Unknown request: MAKE-ACCOUNT" m))))
      dispatch)))

(define acc (make-account 60))

((acc 'withdraw) 5)
((acc 'deposit) 3)
(acc 'balance)

;; I guess a new serialized procedure creation is needed every time
;;  'withdraw and 'deposit are created. If there was some option of lazily
;;  evaluating (protected <argument>), then Ben's solution could be workable.
;;  this way only the first two calls to 'withdraw and 'deposit are properly
;;  serialized.
;;
;; The internet seems to think the change is safe. It's one of those places
;;  where an official set of answers would help a lot.
