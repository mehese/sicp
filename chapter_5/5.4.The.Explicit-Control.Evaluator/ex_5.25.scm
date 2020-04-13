#lang sicp

(#%require racket/include)

(include "scheme-syntax.scm")
(include "machine.scm")
(include "eceval-support.scm")

(define (delay-it exp env)
  (list 'thunk exp env))
(define (thunk? obj) (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps) env)
            (list-of-delayed-args (rest-operands exps) env))))


(define eceval-operations
  (list
   ;;primitive Scheme operations
   (list 'read read)

   ;;operations in syntax.scm
   (list 'self-evaluating? self-evaluating?)
   (list 'quoted? quoted?)
   (list 'text-of-quotation text-of-quotation)
   (list 'variable? variable?)
   (list 'assignment? assignment?)
   (list 'assignment-variable assignment-variable)
   (list 'assignment-value assignment-value)
   (list 'definition? definition?)
   (list 'definition-variable definition-variable)
   (list 'definition-value definition-value)
   (list 'lambda? lambda?)
   (list 'lambda-parameters lambda-parameters)
   (list 'lambda-body lambda-body)
   (list 'if? if?)
   (list 'if-predicate if-predicate)
   (list 'if-consequent if-consequent)
   (list 'if-alternative if-alternative)
   (list 'begin? begin?)
   (list 'begin-actions begin-actions)
   (list 'last-exp? last-exp?)
   (list 'first-exp first-exp)
   (list 'rest-exps rest-exps)
   (list 'application? application?)
   (list 'operator operator)
   (list 'operands operands)
   (list 'no-operands? no-operands?)
   (list 'first-operand first-operand)
   (list 'rest-operands rest-operands)
   (list 'cond? cond?)
   (list 'cond->if cond->if)
   (list 'let? let?)
   (list 'let->combination let->combination)
   ;; PROBLEM
   (list 'null? null?)
   (list 'cons cons)
   (list 'thunk? thunk?)
   (list 'thunk-exp thunk-exp)
   (list 'thunk-env thunk-env)
   (list 'delay-it delay-it)
   (list 'list-of-delayed-args list-of-delayed-args) 
   
   ;;operations in eceval-support.scm
   (list 'true? true?)
   (list 'make-procedure make-procedure)
   (list 'compound-procedure? compound-procedure?)
   (list 'procedure-parameters procedure-parameters)
   (list 'procedure-body procedure-body)
   (list 'procedure-environment procedure-environment)
   (list 'extend-environment extend-environment)
   (list 'lookup-variable-value lookup-variable-value)
   (list 'set-variable-value! set-variable-value!)
   (list 'define-variable! define-variable!)
   (list 'primitive-procedure? primitive-procedure?)
   (list 'apply-primitive-procedure apply-primitive-procedure)
   (list 'prompt-for-input prompt-for-input)
   (list 'announce-output announce-output)
   (list 'user-print user-print)
   (list 'empty-arglist empty-arglist)
   (list 'adjoin-arg adjoin-arg)
   (list 'last-operand? last-operand?)
   (list 'no-more-exps? no-more-exps?)	;for non-tail-recursive machine
   (list 'get-global-environment get-global-environment)
   ))

(define eceval
  (make-machine
   '(exp env val proc argl continue unev)
   eceval-operations
  '(
;;SECTION 5.4.4
read-eval-print-loop
  (perform (op initialize-stack))
  (perform
   (op prompt-for-input) (const ";;; EC-Eval (LAZY) input:"))
  (assign exp (op read))
  (assign env (op get-global-environment))
  (assign continue (label print-result))
  (goto (label l:actual-value)) ;; We want to print the actual value of this shit
print-result
;;**following instruction optional -- if use it, need monitored stack
  ;(perform (op print-stack-statistics))
  (perform
   (op announce-output) (const ";;; EC-Eval (FORCED) value:"))
  (perform (op user-print) (reg val))
  (goto (label read-eval-print-loop))

unknown-expression-type
  (assign val (const unknown-expression-type-error))
  (goto (label signal-error))

unknown-procedure-type
  (restore continue)
  (assign val (const unknown-procedure-type-error))
  (goto (label signal-error))

signal-error
  (perform (op user-print) (reg val))
  (goto (label read-eval-print-loop))

;;SECTION 5.4.1
eval-dispatch
  ;(perform (op user-print) (const "'eval-dispatch "))
  ;(perform (op user-print) (reg exp))
  ;(perform (op user-print) (const "\n"))
  (test (op self-evaluating?) (reg exp))
  (branch (label ev-self-eval))
  (test (op variable?) (reg exp))
  (branch (label ev-variable))
  (test (op quoted?) (reg exp))
  (branch (label ev-quoted))
  (test (op assignment?) (reg exp))
  (branch (label ev-assignment))
  (test (op definition?) (reg exp))
  (branch (label ev-definition))
  (test (op if?) (reg exp))
  (branch (label ev-if))
  (test (op lambda?) (reg exp))
  (branch (label ev-lambda))
  (test (op begin?) (reg exp))
  (branch (label ev-begin))
  (test (op cond?) (reg exp)) 
  (branch (label expand-cond))
  (test (op let?) (reg exp))
  (branch (label expand-let))
  ;; It's either an application or some error
  (test (op application?) (reg exp))
  (branch (label ev-application))
  (goto (label unknown-expression-type))

ev-self-eval
  (assign val (reg exp))
  (goto (reg continue))
ev-variable
  (assign val (op lookup-variable-value) (reg exp) (reg env))
  (goto (reg continue))
ev-quoted
  (assign val (op text-of-quotation) (reg exp))
  (goto (reg continue))
ev-lambda
  (assign unev (op lambda-parameters) (reg exp))
  (assign exp (op lambda-body) (reg exp))
  (assign val (op make-procedure)
              (reg unev) (reg exp) (reg env))
  (goto (reg continue))

;(define (actual-value exp env)
;  (force-it (eval exp env)))
l:actual-value
  ;(perform (op user-print) (const "\n"))
  ;(perform (op user-print) (const "\n"))
  ;(perform (op user-print) (const 'actual-value))
  ;(perform (op user-print) (const " "))
  ;(perform (op user-print) (reg exp))
  ;(perform (op user-print) (const "\n"))
  (save continue)
  (assign continue (label l:actual-value-after-eval))
  (goto (label eval-dispatch))
l:actual-value-after-eval
  (assign continue (label l:actual-value-forced))
  (assign exp (reg val))
  (goto (label l:force-it))
l:actual-value-forced
  (restore continue)
  (goto (reg continue))

;(define (force-it obj)
;  (if (thunk? obj)
;      (actual-value (thunk-exp obj) 
;                    (thunk-env obj))
;      obj))
l:force-it
  ;(perform (op user-print) (const 'force-it))
  ;(perform (op user-print) (const " "))
  ;(perform (op user-print) (reg val))
  ;(perform (op user-print) (const "\n"))
  (test (op thunk?) (reg exp))
  (branch (label l:force-it-is-thunk))
  (assign val (reg exp))
  (goto (reg continue))
l:force-it-is-thunk
  (assign env (op thunk-env) (reg exp))
  (assign exp (op thunk-exp) (reg exp))
  (goto (label l:actual-value))

;; FROM
;;
;;  (apply (eval (operator exp) env)
;;         (list-of-values 
;;          (operands exp) 
;;          env)))
;; TO
;;
;;  ((application? exp)
;;   (apply (actual-value (operator exp) env)
;;          (operands exp)
;;          env))
ev-application
  ;(perform (op user-print) (const 'ev-application))
  ;(perform (op user-print) (const " "))
  ;(perform (op user-print) (reg exp))
  ;(perform (op user-print) (const "\n"))
  (save continue)
  (save env)
  (assign unev (op operands) (reg exp))
  (save unev)
  (assign exp (op operator) (reg exp))
  (assign continue (label ev-appl-did-operator))
  ;; we now need to go to actual-value rather than eval
  (goto (label l:actual-value))
ev-appl-did-operator
  (restore argl) ;; operands
  (restore env)
  (assign proc (reg val))
  ;(perform (op user-print) (const 'ev-appl-did-operator))
  ;(perform (op user-print) (reg proc))
  ;(perform (op user-print) (const ", argl: "))
  ;(perform (op user-print) (reg argl))
  ;(perform (op user-print) (const "\n"))
  (goto (label apply-dispatch))
  
apply-dispatch
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-apply))
  (test (op compound-procedure?) (reg proc))  
  (branch (label compound-apply))
  (goto (label unknown-procedure-type))

;FROM
;  (apply-primitive-procedure procedure arguments)
;TO 
;  (apply-primitive-procedure
;            procedure
;            (list-of-arg-values arguments env)))  ; changed 
primitive-apply
  ;(perform (op user-print) (const "'primitive-apply "))
  ;(perform (op user-print) (reg proc))
  ;(perform (op user-print) (const " arguments "))  
  ;(perform (op user-print) (reg argl))
  ;(perform (op user-print) (const "\n"))
  (save exp)
  (save proc)
  (save env)
  (assign exp (reg argl))
  (assign continue (label primitive-apply-computed-argl))
  (goto (label list-of-arg-values))
primitive-apply-computed-argl ;; val should contain (list-of-arg-values arguments env)
  (restore env)
  (restore proc)
  (restore exp)
  (assign argl (reg val))
  (assign val (op apply-primitive-procedure)
          (reg proc)
          (reg argl))
  (restore continue) ;; this was saved in ev-application
  (goto (reg continue))

;
;FROM  
;          ((compound-procedure? procedure)
;           (eval-sequence
;            (procedure-body procedure)
;            (extend-environment
;             (procedure-parameters procedure)
;             arguments
;             (procedure-environment procedure))))))
;TO     
;          ((compound-procedure? procedure)
;           (eval-sequence
;            (procedure-body procedure)
;            (extend-environment
;             (procedure-parameters procedure)
;             (list-of-delayed-args arguments env)   ; changed
;             (procedure-environment procedure))))))
compound-apply
  ;(perform (op user-print) (const "'compound-apply "))
  ;(perform (op user-print) (reg proc))
  ;(perform (op user-print) (const " arguments "))
  ;(perform (op user-print) (reg argl))
  ;(perform (op user-print) (const "\n"))
  (assign unev (op procedure-parameters)  (reg proc))
  ;; This doesn't need evaluation, so we can save ourselves some work
  (assign argl (op list-of-delayed-args) (reg argl) (reg env))
  (assign env  (op procedure-environment) (reg proc))  
  (assign env (op extend-environment)
          (reg unev) (reg argl) (reg env))
  (assign unev (op procedure-body) (reg proc))
  (goto (label ev-sequence))

; Need to implement this *inside* here because we are doing a call to actual-value
;
;  (define (list-of-arg-values exps env)
;    (if (no-operands? exps)
;        '()
;        (cons (actual-value (first-operand exps) env)
;              (list-of-arg-values (rest-operands exps) env))))
list-of-arg-values
  ;(perform (op user-print) (const list-of-arg-values))
  ;(perform (op user-print) (reg exp))
  ;(perform (op user-print) (const "\n"))
  (test (op no-operands?) (reg exp))
  (branch (label list-of-arg-values-base-case)) ;; '() &  jmp to continue
  ;RECURSE
  ;  1. compute (actual-value (first-operand exps) env)
  (save continue)
  (save env)
  (save exp)
  (assign exp (op first-operand) (reg exp))
  (assign continue (label list-of-arg-values-computed-actual-value))
  (goto (label l:actual-value))
;  1. compute (list-of-arg-values (rest-operands exps) env)
list-of-arg-values-computed-actual-value
  (restore exp)
  (restore env)
  (assign continue (label list-of-arg-values-computed-recursion))
  (save val)
  (assign exp (op rest-operands) (reg exp))
  ; 3. compute (cons (actual-value (first-operand exps) env)
  ;                  (list-of-arg-values (rest-operands exps) env))
  (goto (label list-of-arg-values))
list-of-arg-values-computed-recursion
  (restore unev) ; (actual-value (first-operand exps) env)
  (restore continue)
  (assign val (op cons) (reg unev) (reg val))
  (goto (reg continue))
list-of-arg-values-base-case
  (assign val (const ()))
  (goto (reg continue))

  
;;;SECTION 5.4.2
ev-begin
  (assign unev (op begin-actions) (reg exp))
  (save continue)
  (goto (label ev-sequence))

ev-sequence
  (assign exp (op first-exp) (reg unev))
  (test (op last-exp?) (reg unev))
  (branch (label ev-sequence-last-exp))
  (save unev)
  (save env)
  (assign continue (label ev-sequence-continue))
  (goto (label eval-dispatch))
ev-sequence-continue
  (restore env)
  (restore unev)
  (assign unev (op rest-exps) (reg unev))
  (goto (label ev-sequence))
ev-sequence-last-exp
  (restore continue)
  (goto (label eval-dispatch))

;;;SECTION 5.4.3

;; FROM
;(define (eval-if exp env)
;  (if (true? (eval (if-predicate exp) env))
;      (eval (if-consequent exp) env)
;      (eval (if-alternative exp) env)))

;; TO
;(define (eval-if exp env)
;  (if (true? (actual-value (if-predicate exp) 
;                           env))
;      (eval (if-consequent exp) env)
;      (eval (if-alternative exp) env)))
ev-if
  (save exp)
  (save env)
  (save continue)
  (assign continue (label ev-if-decide))
  (assign exp (op if-predicate) (reg exp)) ;; should calculate actual-value
  (goto (label l:actual-value))
ev-if-decide
  (restore continue)
  (restore env)
  (restore exp)
  (test (op true?) (reg val))
  (branch (label ev-if-consequent))
ev-if-alternative
  (assign exp (op if-alternative) (reg exp))
  (goto (label eval-dispatch))
ev-if-consequent
  (assign exp (op if-consequent) (reg exp))
  (goto (label eval-dispatch))

expand-cond
  (assign exp (op cond->if) (reg exp))
  (goto (label ev-if))

expand-let
  (assign exp (op let->combination) (reg exp))
  (goto (label eval-dispatch))

ev-assignment
  (assign unev (op assignment-variable) (reg exp))
  (save unev)
  (assign exp (op assignment-value) (reg exp))
  (save env)
  (save continue)
  (assign continue (label ev-assignment-1))
  (goto (label eval-dispatch))
ev-assignment-1
  (restore continue)
  (restore env)
  (restore unev)
  (perform
   (op set-variable-value!) (reg unev) (reg val) (reg env))
  (assign val (const ok))
  (goto (reg continue))

ev-definition
  (assign unev (op definition-variable) (reg exp))
  (save unev)
  (assign exp (op definition-value) (reg exp))
  (save env)
  (save continue)
  (assign continue (label ev-definition-1))
  (goto (label eval-dispatch))
ev-definition-1
  (restore continue)
  (restore env)
  (restore unev)
  (perform
   (op define-variable!) (reg unev) (reg val) (reg env))
  (assign val (const ok))
  (goto (reg continue))
stopped
   )))

'(EXPLICIT CONTROL EVALUATOR LOADED)

(newline)(newline)
(display "Try me!") (newline)

'(let ((a 2)) (+ a 2)) ;; = 4
'(let ((a 2) (b 4)) (+ a b)) ;; = 6
'(let ((f (lambda (x) (* x x)))) (f 5)) ;; = 25
'((lambda (x) (+ x)) 1) ;; = 1  ✔
'((lambda (x y) (+ x y)) 1 2) ;; = 3  ✔
'(begin
   (define (fact n)
     (if (<= n 1)
         n
         (* n (fact (- n 1)))))
   (fact 6)) ;; = 720 ✔

;; Stuff that works just with lazy evals
'(begin
   (define (try a b)
     (if (= a 0) 1 b))
   
    (try 0 (/ 1 0)))  ;; = 1 ✔

'(begin
   (define (unless condition 
             usual-value 
             exceptional-value)
     (if condition 
         exceptional-value 
         usual-value))

   (define a 1)
   (define b 0)
   (unless (= b 0)
        (/ a b)
        '(error division by  0))) ;; ;; = '(error division by  0) ✔

'(begin
   (define (unless condition 
             usual-value 
             exceptional-value)
     (if condition 
         exceptional-value 
         usual-value))
   
   (define (factorial n) (unless (= n 1)
                           (* n (factorial (- n 1)))
                           1))
   (factorial 3)) ;; = 6 ✔

'((lambda (x y) x) 1 b) ;; = 1 ✔

'(begin
   (define (dec n)
     (if (<= n 1)
         n
         (dec (- n 1))))
   (dec 2)) ;; = 1 ✔

'(begin
   (define (inc n)
     (if (= n 1)
         n
         (inc (+ n 1))))
   (inc 0)) ;; = 1 ✔

(start eceval)