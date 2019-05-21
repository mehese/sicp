#lang sicp

(define (halts? p a)
  #f)

(define (run-forever)
  (run-forever))

(define (try p)
  (if (halts? p p)
      (run-forever)
      'halted))

;; (try try)
;;  if try passes the halts? filter, (try try) will run forever
;;    => halts? gave the WRONG answer
;;  if try fails the halts? filter it will halt
;;    => halts? gave the WRONG answer again
;;
;; Which is exactly the proof that the halting problem lacks a solution,
;;  we can always create a program that checks what halts? has to say on itself
;;  and then proceeds to break its intended behavior
;;
