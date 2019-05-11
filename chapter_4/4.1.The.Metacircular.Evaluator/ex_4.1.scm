#lang sicp


(define no-operands? null?)
(define (first-operand lst) car)
(define (rest-operands lst) cdr)

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values 
             (rest-operands exps) 
             env))))

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values 
             (rest-operands exps) 
             env))))

;; Don't like not being able to check stuff right away, but implementing
;;  eval off the bat is too much work for this one excercise.
(define (list-of-values-l->r exps env)
  (if (no-operands? exps)
      '()
      (let ;; force the evaluation
          ((first-evaluated (eval (first-operand exps) env)))
      (cons first-evaluated
            (list-of-values-l->r 
             (rest-operands exps) 
             env)))))

(define (list-of-values-r->l exps env)
  (if (no-operands? exps)
      '()
      (let
          ((first-evaluated (list-of-values (rest-operands exps)
                                            env)))
      (cons (eval (first-operand exps) env)
            first-evaluated))))
