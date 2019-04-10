(load "logic_gates.scm")
(load "sicp_wire.scm")

;; Problem


;; Experiment 1: agenda with queue

(let* ;; synctactic sugar for nested lets
   ((dummy (load "sicp_agenda.scm"))
    (input-1 (make-wire))
    (input-2 (make-wire))
    (res (make-wire))
    (test-AND (and-gate input-1 input-2 res)))
   
   (probe 'and-result res)
   (set-signal! input-1 0)
   (set-signal! input-2 1)
   
   ;; Flip signals
   
   (set-signal! input-1 1)
   (set-signal! input-2 0)
   
   (propagate))

;; Experiment 2: agenda with stack

(let* 
   ((dummy (load "bad_agenda.scm"))
    (input-1 (make-wire))
    (input-2 (make-wire))
    (res (make-wire))
    (test-AND (and-gate input-1 input-2 res)))
	
   (display "Using Stack") (newline)
   (probe 'and-result res)
   (set-signal! input-1 0)
   (set-signal! input-2 1)
   
   ;; Flip signals
   
   (set-signal! input-1 1)
   (set-signal! input-2 0)
   
   (propagate))

