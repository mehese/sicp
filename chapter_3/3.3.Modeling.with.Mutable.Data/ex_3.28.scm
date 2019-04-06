#lang sicp

;; Don't know how to sleep sicp just yet
(#%require (only racket/base sleep))

;; Prerequisites
(define (make-wire)
  (define wire-state 0)

  ;; Wires can have multiple upstream tasks
  (define procedures-to-run
    (list
     (lambda () nil)))

  (define (push-upstream)
    (map (lambda (x) (x)) procedures-to-run))

  (define (set-signal! signal)
    (if (= wire-state signal)
        (begin
          wire-state)
        (flip!)))

  (define (add-action! action)
    (set-cdr! procedures-to-run (cons action (cdr procedures-to-run))))

  (define (flip!)
    (if (= 0 wire-state)
        (set! wire-state 1)
        (set! wire-state 0))
    (push-upstream)
    wire-state)

  (define (dispatch m)
    (cond
      ((eq? m 'get-signal) wire-state)
      ((eq? m 'set-signal!) set-signal!)
      ((eq? m 'add-action!) add-action!)
      ((eq? m 'procedure) procedures-to-run)
      ((eq? m 'flip) (flip!))
      ((eq? m 'boo) "Boo")
      (else
       (error "Unrecognized message"))))

  dispatch)

(define (after-delay wait-time function-to-run)
  (sleep wait-time)
  (function-to-run))

(define (flip! wire) (wire 'flip))
(define (set-signal! wire value) ((wire 'set-signal!) value))
(define (add-action! wire function) ((wire 'add-action!) function))

(define (get-signal wire) (wire 'get-signal))

(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))

(define inverter-delay 0.5)
(define and-gate-delay 0.3)

(define (inverter input output)
  (define (invert-input)
    (let ((new-value 
           (logical-not (get-signal input))))
      (after-delay 
       inverter-delay
       (lambda ()
         (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define (logical-and s1 s2)
  (if (and (= 1 s1) (= 1 s2))
      1
      0))

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) 
                        (get-signal a2))))
      (after-delay 
       and-gate-delay
       (lambda ()
         (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

(define a (make-wire))
(define b (make-wire))
(define c (make-wire))
(define d (make-wire))
(define e (make-wire))
(define s (make-wire))
(define IN (make-wire))
(define OUT (make-wire))

(define AND-1 (and-gate a b c))
(define NOT-1 (inverter IN OUT))
(display "Testing Inverter")(newline)
(display "Turning on input for inverter ") (set-signal! IN 1)
(display "Inverter output is now ") (get-signal OUT) ; ✔
(display "Turning on input for inverter ") (set-signal! IN 0)
(display "Inverter output is now ") (get-signal OUT)
(display "Testing AND gate") (newline)
(display "Turning on signal a for AND ") (set-signal! a 1)
(display "Turning on signal b for AND ") (set-signal! b 1)
(display "Signal on AND gate is now ") (get-signal c) ; ✔


;; Problem
(define (logical-or s1 s2)
  (if (or (= 1 s1) (= 1 s2))
      1
      0))

(define or-gate-delay 2)

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
           (logical-or (get-signal a1) 
                       (get-signal a2))))
      (after-delay 
       or-gate-delay
       (lambda ()
         (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)

(display "Testing OR") (newline)
(define OR (or-gate d e s))
(define d2 (make-wire))
(define e2 (make-wire))
(define s2 (make-wire))
(define OR-2 (or-gate d2 e2 s2))
(display "Switching on wire e ")(set-signal! e 1)
(display "⇨ Signal on wire s ")(get-signal s) ; ✔
(display "⇨ Signal on wire s2 ")(get-signal s2) ; ✔
(display "Switching off wire e ")(set-signal! e 0)
(display "⇨ Signal on wire s ")(get-signal s); ✔
(display "Switching on wire d ")(set-signal! d 1)
(display "⇨ Signal on wire s ")(get-signal s); ✔
(display "Switching off wire e ")(set-signal! e 0)
(display "Switching off wire d ")(set-signal! d 0)
(display "Switching on wire e ")(set-signal! e 1)
(display "Switching on wire d ")(set-signal! d 1)
(display "⇨ Signal on wire s ")(get-signal s); ✔