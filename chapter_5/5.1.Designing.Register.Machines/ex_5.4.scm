#lang sicp

;; Iterative version
(define (expti b n)
  (define (expt-iter counter product)
    (if (= counter 0)
        product
        (expt-iter (- counter 1)
                   (* b product))))
  (expt-iter n 1))

'(controller
  (assign b (op read))
  (assign counter (op read)) ;; basically the exponent n
  (assign product (const 1.0))
  expt-loop
  (test (op =) (reg counter) (const 0.0))
  (branch (label expt-done))
  (assign counter (op -) (reg counter) (const 1))
  (assign product (op *) (reg product) (reg b))
  (goto (label expt-loop))
  expt-done
  (perform (op print) (reg product)))

;; Recursive version (uses stack)
(define (exptr b n)
  (if (= n 0)
      1
      (* b (exptr b (- n 1)))))

'(controller
  (assign b (op read))
  (assign n (op read))
  (assign product (const 1.0))
  (assign continue(label expt-done))

  expt-loop
  (test (op =) (reg n) (const 0))
  (branch label base-case)
  (save continue)
  (assign n (op -) (reg n) (const 1))
  (assign continue (label after-exp))
  (goto (label expt-loop))
  
  after-expt
  (restore continue)
  (assign product (op *) (reg b) (reg product))
  (goto (reg continue))

  base-case
  (assign product (const 1))
  (goto (reg continue))

  expt-done
  (perform (op print) (reg product))
  )
