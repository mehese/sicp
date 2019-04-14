(define (parallel-execute . fun-list)
  (map (lambda (x) (x)) fun-list))

(define (make-serializer)
  (lambda (x) x))

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin 
          (set! balance 
                (- balance amount))
          balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) 
             (protected withdraw))
            ((eq? m 'deposit) 
             (protected deposit))
            ((eq? m 'balance)
             ((protected 
                (lambda () 
                  balance)))) ; serialized
            (else 
             (error 
              "Unknown request: 
               MAKE-ACCOUNT"
              m))))
    dispatch))

(define acc (make-account 60))

((acc 'withdraw) 5)
(acc 'balance)

;; Accessing balance in this way should yield no improvements whatsoever, so Ben's 
;;  tweak doesn't really improve anything, as always. One possible scenario where
;;  it could help would be if there was a fee for checking your balance. If the 
;;  retrieve balance procedure would be
;;   (begin
;;     (set! balance (- balance 0.01))
;;     balance)
;; 
;;  In that case we would need the balance operation to be serialized
