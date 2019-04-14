(define (peter-fun balance-struct)
  (let
    ((balance (car balance-struct)))
    (display "Peter adds $10") (newline)
    (set-car! balance-struct
              (+ balance 10))))

(define (paul-fun balance-struct)
  (let
    ((balance (car balance-struct)))
    (display "Paul withdraws $20") (newline)
    (set-car! balance-struct
              (- balance 20))))


(define (mary-fun balance-struct)
  (let
    ((balance (car balance-struct)))
    (display "Mary withdraws $") (display (/ balance 2.0)) (newline)
    (set-car! balance-struct
              (- balance (/ balance 2)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                  ;;
;;                           PART 1                                 ;;
;;                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 3! = 6 possible combinations

(define option-list (list (list peter-fun paul-fun mary-fun)
                          (list peter-fun mary-fun paul-fun)
                          (list paul-fun peter-fun mary-fun)
                          (list paul-fun mary-fun peter-fun)
                          (list mary-fun peter-fun paul-fun)
                          (list mary-fun paul-fun peter-fun)))

(newline)
(define (iterate-option fun-lst)
  (if (null? fun-lst)
      'done 
      (let
        ((balance (list 100))
         (this-option (car fun-lst)))
        (let
          ((f1 (car this-option))
           (f2 (cadr this-option))
           (f3 (caddr this-option)))
          (f1 balance)
          (f2 balance)
          (f3 balance)
          (display "Final balance: ") (display (car balance)) (newline) (newline)
          (iterate-option (cdr fun-lst))))))

(iterate-option option-list)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                  ;;
;;                           PART 2                                 ;;
;;                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Possible timings
;;  A. Everyone accesses the account at the same time
;;         => the final value of the balance will depend only on which 
;;            transaction gets processed last, as the previous two changes
;;            will be discarded
;;
;;  B. The account is accessed at two time intervals
;;      (a). 2 people at t0 and 1 person at t1
;;         => Options are: (Mary, Paul) -> Peter
;;                         (Mary, Peter) -> Paul
;;                         (Paul, Peter) -> Mary
;;         => Effects are: (Mary -> Peter) OR (Paul -> Peter)
;;                         (Mary -> Paul)  OR (Peter -> Paul)
;;                         (Paul -> Mary)  OR (Peter -> Mary)
;;      (b). 1 person at t0 and 2 persons at t1
;;         => Options are: Peter -> (Mary, Paul) 
;;                         Paul  -> (Mary, Peter)
;;                         Mary  -> (Paul, Peter)
;;         => Effects are the same as B.(a)
;;  C. They all access it at different times 
;;         => basically the results in part 1

;; Example A: Mary gets processed last
;; 
;;     +    BANK               PETER                PAUL                   MARY
;;     |
;;     | +-------+
;;     | |  100  +----------------------------------------------------------+
;;     | +-------+               |                    |                     |
;;  t  |                 +-------v-------+            |                     |
;;  i  | +-------+       |               |            |                     |
;;  m  | |  110  +<------+ balance += 10 |            |                     |
;;  e  | +-------+       |               |            |                     |
;;     |                 +---------------+    +-------v-------+             |
;;     | +-------+                            |               |             |
;;     | |   80  +<---------------------------+ balance -= 20 |             |
;;     | +-------+                            |               |             v
;;     |                                      +---------------+    +-----------------+
;;     | +-------+                                                 |             100 |
;;     | |   50  +<------------------------------------------------+  balance -= --- |
;;     | +-------+                                                 |              2  |
;;     |                                                           +-----------------+
;;     |
;;     v

;; Example B: Peter and Paul get proccessed at the same time, Mary gets processed after
;; 
;;     +    BANK               PETER                PAUL
;;     |
;;     | +-------+
;;     | |  100  +------------------------------------+
;;     | +-------+               |                    |
;;  t  |                 +-------v-------+            |
;;  i  | +-------+       |               |            |
;;  m  | |  110  +<------+ balance += 10 |            |
;;  e  | +-------+       |               |            |
;;     |                 +---------------+    +-------v-------+
;;     | +-------+                            |               |
;;     | |   80  +<---------------------------+ balance -= 20 |
;;     | +-------+                            |               |            MARY
;;     |                                      +---------------+
;;     | +-------+
;;     | |   80  +----------------------------------------------------------+
;;     | +-------+                                                          |
;;     |                                                           +--------v--------+
;;     | +-------+                                                 |             80  |
;;     | |   40  +<------------------------------------------------+  balance -= --  |
;;     | +-------+                                                 |              2  |
;;     |                                                           +-----------------+
;;     v


