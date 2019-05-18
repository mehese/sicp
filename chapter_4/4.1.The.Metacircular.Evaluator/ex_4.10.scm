#lang sicp

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

;; I shall hereby name this new language Schema Schemelor!
(define (assignment? exp)
  (tagged-list? exp 'setează!))

(define (definition? exp)
  (tagged-list? exp 'definește))

(define (lambda? exp) 
  (tagged-list? exp 'lambdă))

(define (let? exp)
  (tagged-list? exp 'lasă))

(define (begin? exp) 
  (tagged-list? exp 'începe))

(define (if? exp)
  (tagged-list? exp 'dacă))

(define (cond? exp) 
  (tagged-list? exp 'condiție))

(define (for? exp)
  (tagged-list? exp 'pentru))

(define (while? exp)
  (tagged-list? exp 'cât-timp))


(define (make-lambda parameters body)
  (cons 'lambdă (cons parameters body)))

(define (make-let var exp body)
  (append (list 'lasă (list (list var exp))) body))

(define (make-if predicate 
                 consequent 
                 alternative)
  (list 'dacă 
        predicate 
        consequent 
        alternative))

(define (make-begin seq) (cons 'începe seq))

(define (make-variable-definition variable definition)
  (list 'definește variable definition))

;; Here http://community.schemewiki.org/?sicp-ex-4.10 the guy also implemented a postfix operator
;;  but that would require rebuilding all the make functions, which is t(-_-t)

;; Nothing of interest below

(define (eval exp env)
  (cond ((self-evaluating? exp) 
         exp)
        ((variable? exp) 
         (lookup-variable-value exp env))
        ((quoted? exp) 
         (text-of-quotation exp))
        ((assignment? exp)
         (eval-assignment exp env))
        ((definition? exp)
         (display "I am a definition ")
         (eval-definition exp env))
        ((if? exp) 
         (eval-if exp env))
        ((lambda? exp)
         (make-procedure 
          (lambda-parameters exp)
          (lambda-body exp)
          env))
        ((let? exp)
         (eval (let->combination exp) env))
        ((for? exp) ;; for x in lst do implementation
         (eval (for->combination exp) env))
        ((while? exp) ;; while syntax implementation
         (eval (while->combination exp) env))
        ((begin? exp)
         (eval-sequence 
          (begin-actions exp) 
          env))
        ((cond? exp)
         (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values 
                 (operands exp) 
                 env)))
        (else
         (error "Unknown expression 
                 type: EVAL" exp))))

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

(define (assignment-variable exp) 
  (cadr exp))

(define (assignment-value exp) (caddr exp))


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


(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))


(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

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

(define (let-variables exp)
  (map car (cadr exp)))

(define (let-body exp)
  (cddr exp))

(define (let-expressions exp)
  (map cadr (cadr exp)))

(define (let->combination exp)
  (cons (make-lambda (let-variables exp) (let-body exp))
        (let-expressions exp)))

(define (for-variable exp)
  (cadr exp))

(define (for-sequence exp)
  (caddr exp))

(define (for-function exp)
  (cdddr exp))

(define (for->combination exp)
  (let
      ((var (for-variable exp))
       (seq (for-sequence exp))
       (fun (for-function exp)))
    (make-begin
     (map (lambda (exp) (make-let var exp fun)) seq))))

(define (check-condition exp)
  (cadr exp))

(define (while-body exp)
  (cddr exp))

(define (while->combination exp)
  (let
      ((check (check-condition exp))
       (body  (while-body exp)))
    (list
     (list
      (make-lambda
       (list 'r)
       (list (list 'r 'r))) ;; recursion operator
      (make-lambda
       (list 'while)
       (list (make-lambda
              '()
              (list
               (make-if check
                        (make-begin
                         ;; add a recursive call to the body of the while
                         (append body (list (list (list 'while 'while)))))
                        ''done)))))))))

