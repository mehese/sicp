#lang sicp

(#%require racket/include)

(include "scheme-syntax.scm")
(include "machine.scm")
(include "eceval-support.scm")

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
   (op prompt-for-input) (const ";;; EC-Eval input:"))
  (assign exp (op read))
  (assign env (op get-global-environment))
  (assign continue (label print-result))
  (goto (label eval-dispatch))
print-result
;;**following instruction optional -- if use it, need monitored stack
  ;(perform (op print-stack-statistics))
  (perform
   (op announce-output) (const ";;; EC-Eval value:"))
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

;; Comment below as per case
ev-application
  (save continue)
  (save env)       ;; can ignore for (f 'x 'y) ((f) 'x 'y) (f (g 'x) y) (f (g 'x) 'y)
  (assign unev (op operands) (reg exp))
  (save unev)      ;; can ignore for (f 'x 'y)             (f (g 'x) y) (f (g 'x) 'y)
  (assign exp (op operator) (reg exp))
  (assign continue (label ev-appl-did-operator))
  (goto (label eval-dispatch))
ev-appl-did-operator
  (restore unev)   ;; can ignore for (f 'x 'y)             (f (g 'x) y) (f (g 'x) 'y)
  (restore env)    ;; can ignore for (f 'x 'y) ((f) 'x 'y) (f (g 'x) y) (f (g 'x) 'y)
  (assign argl (op empty-arglist))
  (assign proc (reg val))
  (test (op no-operands?) (reg unev))
  (branch (label apply-dispatch))
  (save proc)      ;; can ignore for (f 'x 'y) ((f) 'x 'y)
ev-appl-operand-loop
  (save argl)      ;; can ignore for (f 'x 'y) ((f) 'x 'y)
  (assign exp (op first-operand) (reg unev))
  (test (op last-operand?) (reg unev))
  (branch (label ev-appl-last-arg))
  (save env)       ;; can ignore for (f 'x 'y) ((f) 'x 'y) (f (g 'x) y) (f (g 'x) 'y)
  (save unev)      ;; can ignore for (f 'x 'y) ((f) 'x 'y)
  (assign continue (label ev-appl-accumulate-arg))
  (goto (label eval-dispatch))
ev-appl-accumulate-arg
  (restore unev)   ;; can ignore for (f 'x 'y) ((f) 'x 'y)
  (restore env)    ;; can ignore for (f 'x 'y) ((f) 'x 'y) (f (g 'x) y) (f (g 'x) 'y)
  (restore argl)   ;; can ignore for (f 'x 'y) ((f) 'x 'y)
  (assign argl (op adjoin-arg) (reg val) (reg argl))
  (assign unev (op rest-operands) (reg unev))
  (goto (label ev-appl-operand-loop))
ev-appl-last-arg
  (assign continue (label ev-appl-accum-last-arg))
  (goto (label eval-dispatch))
ev-appl-accum-last-arg
  (restore argl)   ;; can ignore for (f 'x 'y) ((f) 'x 'y)
  (assign argl (op adjoin-arg) (reg val) (reg argl))
  (restore proc)   ;; can ignore for (f 'x 'y) ((f) 'x 'y)
  (goto (label apply-dispatch))
apply-dispatch
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-apply))
  (test (op compound-procedure?) (reg proc))  
  (branch (label compound-apply))
  (goto (label unknown-procedure-type))

primitive-apply
  (assign val (op apply-primitive-procedure)
              (reg proc)
              (reg argl))
  (restore continue)
  (goto (reg continue))

compound-apply
  (assign unev (op procedure-parameters) (reg proc))
  (assign env (op procedure-environment) (reg proc))
  (assign env (op extend-environment)
              (reg unev) (reg argl) (reg env))
  (assign unev (op procedure-body) (reg proc))
  (goto (label ev-sequence))

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

ev-if
  (save exp)
  (save env)
  (save continue)
  (assign continue (label ev-if-decide))
  (assign exp (op if-predicate) (reg exp))
  (goto (label eval-dispatch))
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
(display "(f 'x 'y)
((f) 'x 'y)
(f (g 'x) y)
(f (g 'x) 'y)

")     

;'(define (f) (lambda (a b) b))
'(define y 2)
'(define (f a b) (list 'f a b))
'(define (g x) x)

(start eceval)

;; For (f 'x 'y) 
;;   tested with (define (f a b) b) for (f 'x 'y) (f 2 3)
;;   - All the saves and restores (except for continue) can be ignored
;;   - Note that both ev-quoted and ev-variable don't modify registers
;;
;; For ((f) 'x 'y) 
;;   tested with (define (f) (lambda (a b) b)) for (f 'x 'y) (f 2 3)
;;   - We need the unev save before the operator, unless the compiler does
;;     something else with the lambda
;;   - For operand evaluation we don't need and save continues
;;
;; For (f (g 'x) y) 
;;   tested with (define y 2)
;;               (define (f a b) (list 'f a b)) 
;;               (define (g x) x) 
;;   - We can skip saving the env and unev for the application
;;   - For the operators we need to save proc, argl and unev, but in this case env can be skipped
;;     This might not be the general case, as (g x) could modify the env in ways we do not want.
;;     For example if g would be defined like (define (g x) (let ((y 3)) (list y x))) stuff
;;     doesn't work anymore. In fact for this case we can't comment any of the save/restores.
;;
;; For (f (g 'x) 'y) 
;;   tested with (define (f a b) (list 'f a b)) 
;;               (define (g x) x) 
;;   - Same as above, really, it's just that the second argument now goes to ev-quoted, rather
;;     than ev-variable
;;   - We can skip saving the env and unev for the application
;;   - For the operators we need to save proc, argl and unev, we can also skip saving env for all
;;     as no matter how (g x) 
;;
;;
