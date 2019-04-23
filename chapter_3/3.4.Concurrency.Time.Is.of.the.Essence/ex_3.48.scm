#lang sicp

;; This actually runs in parallel because the flow of time in our reality
;;  is just an illusion O_O
(define (parallel-execute . args)
  (map (lambda (fun) (fun)) (reverse args)))

(define (test-and-set! cell)
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))

(define (clear! cell) (set-car! cell false))

(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
                 (the-mutex 'acquire))) ; retry
            ((eq? m 'release) (clear! cell))))
    the-mutex))


(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))


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



(define acc1 (make-account 600))
(define acc2 (make-account 450))
(acc1 'balance)
(acc2 'balance)

;; This is how the old serialized procedure looked like

;(define (serialized-exchange account1 account2)
;  (let ((serializer1 (account1 'serializer))
;        (serializer2 (account2 'serializer)))
;    ((serializer1 (serializer2 exchange))
;     account1
;     account2)))

;; The routine below would run the two swaps in order

;(parallel-execute
; (lambda () (serialized-exchange acc1 acc2))   ;; Peter
; (lambda () (serialized-exchange acc2 acc1)))  ;; Paul

;; Peter's routine at one point would first require to acquire a lock
;;  on account2 and then a lock for account1 before proceeding with the
;;  exchange instructions
;; Paul's routine on the other hand needs a lock on account1 first and
;;  then on account 2 to proceed with his exchange instructions. If the sequence
;;  of operations is
;;  t0: [Peter, acc2] -> acquired lock
;;  t1: [Paul,  acc1] -> acquired lock
;;  t2: [Peter, acc1] -> acquire lock -- here the deadlock will happen, as Peter
;;  t3: [Peter, acc2] -> acquire lock    cannot acquire the lock until Paul releases
;;                                       it But Paul himself is looking to acquire a 
;;                                       lock on acc2 which is now locked
;;
;; The suggested way to avoid this situation is to simply impose a sorting
;;  on the accounts. Above you can see how now every time an account is created
;;  it will be given an integer id. Below is a reimplementation of serialized-exchange
;;  that uses this information.

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer))
        (id1         (account1 'account-id))
        (id2         (account2 'account-id)))
    (if (> id1 id2)
        ((serializer2 (serializer1 exchange))
         account1
         account2)
        ((serializer1 (serializer2 exchange))
         account1
         account2))))

;; Now let's see how this would affect the parallel-execute command shown in the
;;  comment above (provided they run simultaneously)
;;
;; Case 1.A: id acc1 < id acc2, Peter's procedure makes the first call
;;    t0:  [Peter, acc1] -> acquire(d) lock
;;    t1:  [Paul,  acc1] -> acquire lock (waits)
;;    t1:  [Peter, acc2] -> acquire(d) lock
;;    t2:  <Peter's exchange>
;;    t3:  [Peter, acc2] -> releases lock
;;    t4:  [Peter, acc1] -> releases lock
;;    t5:  [Paul,  acc1] -> acquired lock [finally]
;;    t6:  [Paul,  acc2] -> acquire(d) lock
;;    t7:  <Paul's exchange>
;;    t8:  [Paul,  acc2] -> releases lock
;;    t9:  [Paul,  acc1] -> releases lock
;; Case 1.B: id acc1 < id acc2, Paul's procedure makes the first call
;;    t0:  [Paul,  acc1] -> acquire(d) lock
;;    t1:  [Peter, acc1] -> acquire lock (waits)
;;    t1:  [Paul,  acc2] -> acquire(d) lock
;;    t2:  <Paul's exchange>
;;    t3:  [Paul, acc2] -> releases lock
;;    t4:  [Paul, acc1] -> releases lock
;;    t5:  [Peter,  acc1] -> acquired lock [finally]
;;    t6:  [Peter,  acc2] -> acquire(d) lock
;;    t7:  <Peter's exchange>
;;    t8:  [Peter,  acc2] -> releases lock
;;    t9:  [Peter,  acc1] -> releases lock
;; Case 2.A: id acc1 > id acc2, Peter's procedure makes the first call
;;    t0:  [Peter, acc2] -> acquire(d) lock
;;    t1:  [Paul,  acc2] -> acquire lock (waits)
;;    t1:  [Peter, acc1] -> acquire(d) lock
;;    t2:  <Peter's exchange>
;;    t3:  [Peter, acc1] -> releases lock
;;    t4:  [Peter, acc2] -> releases lock
;;    t5:  [Paul,  acc2] -> acquired lock [finally]
;;    t6:  [Paul,  acc1] -> acquire(d) lock
;;    t7:  <Paul's exchange>
;;    t8:  [Paul,  acc1] -> releases lock
;;    t9:  [Paul,  acc2] -> releases lock
;; Case 2.B: id acc1 > id acc2, Paul's procedure makes the first call
;;    t0:  [Paul,  acc2] -> acquire(d) lock
;;    t1:  [Peter, acc2] -> acquire lock (waits)
;;    t1:  [Paul,  acc1] -> acquire(d) lock
;;    t2:  <Paul's exchange>
;;    t3:  [Paul,  acc1] -> releases lock
;;    t4:  [Paul,  acc2] -> releases lock
;;    t5:  [Peter, acc2] -> acquired lock [finally]
;;    t6:  [Peter, acc1] -> acquire(d) lock
;;    t7:  <Peter's exchange>
;;    t8:  [Peter, acc1] -> releases lock
;;    t9:  [Peter, acc2] -> releases lock
;;
;; As you see, all cases can run successfully 


(parallel-execute
 (lambda () (serialized-exchange acc1 acc2))   ;; Peter
 (lambda () (serialized-exchange acc2 acc1)))  ;; Paul

(acc1 'balance)
(acc2 'balance)