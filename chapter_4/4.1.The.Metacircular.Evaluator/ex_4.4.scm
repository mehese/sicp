#lang sicp

;; Racket hash table
(#%require (only racket/base make-hash))
(#%require (only racket/base hash-set!))
(#%require (only racket/base hash-ref))

(define *op-table* (make-hash))

(define (put op type proc)
  (hash-set! *op-table* (list op type) proc))

(define (get op type)
  (hash-ref *op-table* (list op type) #f))

;; Mock functions since I don't like errors
(define (lookup-variable-value exp env)
  'bump)

(define (make-procedure params body env)
  'bump)

(define (primitive-procedure? proc)
  'bump)

(define (compound-procedure? proc)
  'bump)

(define (apply-primitive-procedure procedure arguments)
  'bump)

(define (procedure-body procedure)
  'bump)

(define (procedure-parameters procedure)
  'bump)

(define (procedure-environment procedure)
  'bump)

(define (extend-environment new-variables new-values base-environment)
  'bump)

(define (true? . args)
  #t)

(define (set-variable-value! variable assignment-val env)
  'bump)

(define (define-variable! var-name value environment)
  'bump)

;; Actual problem

(define (check-all-clauses clauses env)
  (if (eval (car clauses) env)
      (if (null? (cdr clauses))
          (eval (car clauses) env)
          (check-all-clauses (cdr clauses) env))
      #f))

(define (check-at-least-one-clause clauses env)
  (if (null? clauses)
      #f
      (if (eval (car clauses) env)
          (eval (car clauses) env)
          (check-at-least-one-clause (cdr clauses) env))))

(define (eval-and exp env)
  (check-all-clauses (cond-clauses exp) env))

(define (eval-or exp env)
  (check-at-least-one-clause (cond-clauses exp) env))

(put 'eval 'and (lambda (exp env) (eval-and exp env)))
(put 'eval 'or  (lambda (exp env) (eval-or  exp env)))

;; More stuff to make stuff work below

(put 'eval 'quote   (lambda (exp env) (text-of-quotation exp)))
(put 'eval 'set!    (lambda (exp env) (eval-assignment exp env)))
(put 'eval 'define  (lambda (exp env) (eval-definition exp env)))
;; needs booleans to be self-evaluating for  (eval  '(if #t 1 2) '())
(put 'eval 'if      (lambda (exp env) (eval-if exp env)))
(put 'eval 'lambda  (lambda (exp env) (make-procedure  (lambda-parameters exp)
                                                       (lambda-body exp)
                                                                    env)))
(put 'eval 'begin   (lambda (exp env) (eval-sequence (begin-actions exp) env)))
(put 'eval 'cond    (lambda (exp env) (eval (cond->if exp) env)))

(define (eval exp env)
  (cond ((self-evaluating? exp) 
         exp)
        ((variable? exp) 
         (lookup-variable-value exp env))
        
        ((get 'eval (operator exp))
         ((get 'eval (operator exp)) exp env))
        (else
         ;; If all else fails, apply the operator
         (apply (eval (operator exp) env)
                (list-of-values 
                 (operands exp) 
                 env)))))
       
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
         (error "Unknown procedure type: APPLY" procedure))))

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        ((boolean? exp) true) ;; Otherwise if evaluations fail
        (else false)))

(define (variable? exp) (symbol? exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp)
  (cadr exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) 
  (cadr exp))

(define (assignment-value exp) (caddr exp))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)    ;; (define a 42), returns a 
      (caadr exp))) ;; (define (a x) 42), returns a

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda 
       (cdadr exp)   ; formal parameters
       (cddr exp)))) ; body

(define (lambda? exp) 
  (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate 
                 consequent 
                 alternative)
  (list 'if 
        predicate 
        consequent 
        alternative))

(define (begin? exp) 
  (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (cond? exp) 
  (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) 
  (car clause))
(define (cond-actions clause) 
  (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
      'false     ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp 
                 (cond-actions first))
                (error "ELSE clause isn't 
                        last: COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp 
                      (cond-actions first))
                     (expand-clauses 
                      rest))))))

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values 
             (rest-operands exps) 
             env))))

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) 
         (eval (first-exp exps) env))
        (else 
         (eval (first-exp exps) env)
         (eval-sequence (rest-exps exps) 
                        env))))

(define (eval-assignment exp env)
  (set-variable-value! 
   (assignment-variable exp)
   (eval (assignment-value exp) env)
   env)
  'ok)

(define (eval-definition exp env)
  (define-variable! 
    (definition-variable exp)
    (eval (definition-value exp) env)
    env)
  'ok)