;; Problem


;; Experiment 1: agenda with queue

(let* ;; syntactic sugar for nested lets
    ((dummy1 (load "sicp_wire.scm"))
     (dummy2 (load "sicp_agenda.scm"))
     (dummy3 (load "logic_gates.scm"))
     (A (make-wire))
     (B (make-wire))
     (S (make-wire))
     (test-AND (and-gate A B S)))

  (display "Using Queue") (newline)
  (probe 'A-val A)
  (probe 'B-val B)
  (probe 'and-result S)
  (propagate)

  ;; Step 1: turn on B (system goes to state 1,0)
  (set-signal! B 1)
  (propagate)

  ;; Step 2: turn on A (system goes to state 1,1)
  (set-signal! A 1) ; Set S to 1 in agenda

  ;; Step 3: turn off B (system goes to state 0,1)
  (set-signal! B 0) ; Set S to 0 in agenda

  ;; First item in queue:
  ;;   Set S to 1
  ;; Second (and final) item in queue
  ;;   Set S to 0 ✔
  (propagate))

(newline) (newline) (newline)

;; Experiment 2: agenda with stack
(let* ;; syntactic sugar for nested lets
    ((dummy1 (load "bad_agenda.scm"))
     (dummy2 (load "sicp_wire.scm"))
     (dummy3 (load "logic_gates.scm"))
     (A (make-wire))
     (B (make-wire))
     (S (make-wire))
     (test-AND (and-gate A B S)))

  (display "Using Stack") (newline)
  (probe 'A-val A)
  (probe 'B-val B)
  (probe 'and-result S)
  (propagate)

  ;; Step 1: turn on B (system goes to state 1,0)
  (set-signal! B 1) ; set S to 0
  (propagate) ;; Need to run this here to observe the error
  ;; S is set to 0

  ;; Step 2: turn on A (system goes to state 1,1)
  (set-signal! A 1) ; set S to 1 in agenda

  ;; Step 2: turn off B (system goes to state 0,1)
  (set-signal! B 0) ; set S to 0 in agenda

  ;; First item in stack
  ;;   Set S to 0
  ;; Second (and final) item in stack
  ;;   Set S to 1 -- WRONG 
  (propagate))


;; Essentially a queue preserves the order of actions we took, i.e. enforces causality
;; Using a stack will result in mutating the system in a different order from the one
;; that was intended -> bad results.
  