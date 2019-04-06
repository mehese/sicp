;; run with
;;  racket -l sicp --repl < ex_3.29.scm
;; Don't know how to sleep sicp just yet
(#%require (only racket/base sleep))

(load "circuit_functions.scm")

;; Remember De Morgan's laws
;; ¬(P or Q) = (¬P) and (¬Q)
;; => (P or Q) = ¬((¬P) and (¬Q))
(define A (make-wire))
(define B (make-wire))
(define A2 (make-wire))
(define B2 (make-wire))
(define C (make-wire))
(define OUT (make-wire))
(define NOT-A (inverter A A2))
(define NOT-B (inverter B B2))
(define AND-node (and-gate A2 B2 C))
(define NOT-C (inverter C OUT))
(newline)
(display "0 ∨ 0") (newline)
(display "Setting A to ") (set-signal! A 0)
(display "Setting B to ") (set-signal! B 0)
(display "Result: ") (get-signal OUT); ✔
(newline)
(display "1 ∨ 0") (newline)
(display "Setting A to ") (set-signal! A 1)
(display "Result: ") (get-signal OUT); ✔
(newline)
(display "1 ∨ 1") (newline)
(display "Setting B to ") (set-signal! B 1)
(display "Result: ") (get-signal OUT); ✔
(newline)
(display "0 ∨ 1") (newline)
(display "Setting A to ") (set-signal! A 0)
(display "Result: ") (get-signal OUT); ✔

;; The total delay time is
;;  3*(inverter-delay) + and-delay
;;
;; If we were to parallelize the entering inverter delays this
;;  would be reduced to
;;  2*(inverter-delay) + and-delay
