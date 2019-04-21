;; Fake parallelizer and serializer
(define (parallel-execute . fun-list)
  (map (lambda (x) (x)) (reversed fun-list)))

(define (make-serializer)
  ;; This mock serializer won't prove the point of this problem
  (lambda (x) x))

(define (make-account-and-serializer balance)

  (define (withdraw amount)
    (if (>= balance amount)
        (begin 
          (set! balance (- balance amount))
          balance)
        "Insufficient funds"))

  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)

  (let 
    ((balance-serializer (make-serializer)))

    (define (dispatch m)
      (cond ((eq? m 'withdraw) (balance-serializer withdraw)) ; used to return unserialized withdraw
            ((eq? m 'deposit) (balance-serializer deposit)) ; used to return unserialized deposit
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request: MAKE-ACCOUNT" m))))

    dispatch))

(define (deposit account amount)
  ((account 'deposit) amount))

(define acc (make-account-and-serializer 500))
(deposit acc 50)

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ;; Notice that this is used to call unserialized operations
    ;;  but now they will be calls to serialized ops
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    ;; This is the place where we run into problems, as we're using a 
    ;;  serializer on a procedure that was already serialized with the
    ;;  *same* serializer.
    ((serializer1 (serializer2 exchange))
     account1
     account2)))    



(define acc2 (make-account-and-serializer 499))

(display "---------")
(acc 'balance)
(acc2 'balance)
(display "Exchanging")
(serialized-exchange acc acc2)
;; With the procedure I'm using in lieu of an actual serializer this exchange 
;;  actually work. However implementing serializers is only done in the next 
;;  section.
