(load "mutex.scm")

;; Consider a situation where a process must get access to some shared resources
;;  before it can know which additional shared resources it will require. 

;; My initial thinking was to just have a function that debits from one account
;;  to a list of other accounts. However this does not necessarily break the 
;;  behaviour serialized-exchange, as one doesn't need to hold the debitted account
;;  locked for entire duration of the procedure, only at each debit, which shouldn't (?)
;;  result in deadlocks. It would make a nice segue into the streams chapter that follows
;;  though...

;; One possibility suggested online http://sicp.csrg.org/#orgheadline195 is to have
;;  mutable account ids, which requires that access to them is serialized -- but one
;;  would need a way of sorting access to the account IDs themselves!

;; I think this is a more correct way of addressing the requirements of this problem.

;; Observe that the procedure now takes an account id as well
(define (make-account-and-serializer balance acc-id)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin 
          (set! balance (- balance amount))
          balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer 
         (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) 
             balance-serializer)
            ((eq? m 'account-id) acc-id)
            ;; New condition that makes our function all deadlocky
            ((eq? m 'increment-id-by-2) 
             (set! acc-id (+ 2 acc-id)))
            (else (error "Unknown request: 
                          MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (create-new-account-set)
  (let
      ((num-accounts 0)
       (safety (make-mutex))) ;; Tbh, I find the mutex more readable
                              ;;  than encapsulating stuff in a serializer
    (define (dispatch m)
      (cond
        ((eq? m 'new)
         (safety 'acquire)
         (let*
             ((acc-no num-accounts)
              (creation-fun (lambda (balance)
                                (make-account-and-serializer balance acc-no))))
           (set! num-accounts (inc num-accounts))
           (safety 'release)
           creation-fun))
        (else
         (error "Message not understood" m))))
    dispatch))


(define account-set (create-new-account-set))
(define (make-account balance) ((account-set 'new) balance))

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer))
        (id1         (account1 'account-id))
        (id2         (account2 'account-id)))
    ;; This is the bit that will give us the deadlock we want so much
    (account1 'increment-id-by-2)
    (if (> id1 id2)
        ((serializer2 (serializer1 exchange))
         account1
         account2)
        ((serializer1 (serializer2 exchange))
         account1
         account2))))


(define acc1 (make-account 600))
(define acc2 (make-account 450))

(acc1 'balance)
(acc2 'balance)
;; Here's how things could fail below
;;  t0 Peter gets ids 0 & 1
;;  t1 Peter increments id of acc1 to 2
;;  t3 Peter acquires lock on mutex of acc1
;;  t4 Paul gets ids 2 & 1
;;  t5 Paul  acquires lock on mutex of acc2
;;    => Deadlock as they will each want next a lock on the
;;       mutexes locked by the other
(display "Changing everything at once")
(parallel-execute
 (lambda () (serialized-exchange acc1 acc2))   ;; Peter
 (lambda () (serialized-exchange acc2 acc1)))  ;; Paul
(newline)
(acc1 'balance)
(acc2 'balance)
