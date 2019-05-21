#lang sicp

;; Actual problem

;(let ((a 1))
;  (define (f x)
;    (define b (+ a x))
;    (define a 5)
;    (+ a b))
;  (f 10))

;; Throws error: a: undefined; cannot use before initialization (aka Alyssa's)

;; Which (if any) of these viewpoints do you support? Can you devise
;;  a way to implement internal definitions so that they behave as Eva prefers?
;;
;; From the footnote: Eva's opinion makes sense, but Alyssa's is easier to implement.
;;  Alyssa does have a point -- the whole reason why we started on this whole
;;  assigned vs unassigned journey was to be able to have mutually recursive definitions,
;;  which would make sequential evaluation nonsensical.
;;
;; The only way I would see Eva's version working is having a fully lazily evaluated language.
;;  Thus when we're trying to compute (+ a b) we would see what the the dependency graph looks
;;  like:
;;
;;   x --------+
;;             |
;;             v
;; +------->(+ a x)---------+
;; |                        |
;; |                        v
;; a ------------------>(+ a  b)
;;
;; Making such an interpreter sounds like really hard work, and I definitely won't do it
;;  for just one excercise in a book that still has loads of long dull tasks for me to slave
;;  through. Also, if the creators of MIT scheme weren't bothered ¯\_(ツ)_/¯. Also the fully
;;  lazy picture would be very hard to square with the assignment operators. How do we determine
;;  the sequentiality of what we're doing?  What if there is a set! operation under the define?
;;  Does it count for the evaluation of b? Do we impose outright a hierarchy of evaluation
;;  precedence?


;; Ignore below
(define (true? x)
  (not (eq? x false)))

(define (false? x)
  (eq? x false))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'add (lambda (x y) (+ x y)))
        (list 'sub (lambda (x y) (- x y)))
        (list 'true? true?)
        #| add more primitives here |# ))
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) 
         (list 'primitive (cadr proc)))
       primitive-procedures))

(define (primitive-implementation proc) 
  (cadr proc))

(define (apply-in-underlying-scheme proc args)
  (apply proc args))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" 
                 vars 
                 vals)
          (error "Too few arguments supplied" 
                 vars 
                 vals))))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())


(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! 
              var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

(define (setup-environment)
  (let ((initial-env
         (extend-environment 
          (primitive-procedure-names)
          (primitive-procedure-objects)
          the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define the-global-environment 
  (setup-environment))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop 
              (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? '*unassigned* (car vals))
                 (error "Value for variable is unassigned!" var)
                 (car vals)))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))


(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop 
              (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable: SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))


(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-body p) (cddr p))

(define (procedure-parameters p) (cadr p))

(define (make-procedure parameters body env)
  (list 'procedure parameters  (scan-out-defines body) env))

(define (procedure-environment p) (cadddr p))

(define (zip-definitions vars exps)
  (if (not (= (length vars) (length exps)))
      (error "Different number of variabls and expressions provided")
      (if (null? vars)
          '()
          (cons (list (car vars) (car exps))
                (zip-definitions (cdr vars) (cdr exps))))))

(define (make-multiple-let variables expressions body)
  (append
   (list
    'let
    (zip-definitions variables expressions))
   body))

(define (scan-out-defines exp-body)
  (define (extract-definitions body-slice
                               variables-so-far
                               definitions-so-far
                               fixed-body)
    (if (null? body-slice)
        (if (null? variables-so-far)
            exp-body ;; body has no defines
            (make-multiple-let variables-so-far definitions-so-far fixed-body))
        (let
            ((current-subexp (car body-slice))
             (rest-body-slice (cdr body-slice)))
          (if (definition? current-subexp)
              (extract-definitions
               rest-body-slice
               (append variables-so-far
                       (list (definition-variable current-subexp)))
               (append definitions-so-far
                       (list '*unassigned*))
               (append fixed-body
                       (list (list 'set!
                                   (definition-variable current-subexp)
                                   (definition-value    current-subexp)))))
               
              (extract-definitions
               rest-body-slice
               variables-so-far
               definitions-so-far
               (append fixed-body
                       (list current-subexp)))))))
  (extract-definitions exp-body '() '() '()))

(define (m-apply procedure arguments)
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
         (display procedure) (newline)
         (display (primitive-procedure? procedure)) (newline)
         (error "Unknown procedure type: APPLY" procedure))))

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
        ((begin? exp)
         (eval-sequence 
          (begin-actions exp) 
          env))
        ((cond? exp)
         (eval (cond->if exp) env))
        ((application? exp)
         (m-apply (eval (operator exp) env)
                  (list-of-values 
                   (operands exp) 
                   env)))
        (else
         (error "Unknown expression 
                 type: EVAL" exp))))

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


(define (let? exp)
  (tagged-list? exp 'let))

(define (let-variables exp)
  (map car (cadr exp)))

(define (let-body exp)
  (cddr exp))

(define (let-expressions exp)
  (map cadr (cadr exp)))

(define (let->combination exp)
  (cons (make-lambda (let-variables exp) (let-body exp))
        (let-expressions exp)))

(define (make-let var exp body)
  (append (list 'let (list (list var exp))) body))

(define (make-variable-definition variable definition)
  (list 'define variable definition))

(define input-prompt  ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (user-print object)
  (if (compound-procedure? object)
      (display 
       (list 'compound-procedure
             (procedure-parameters object)
             (procedure-body object)
             '<procedure-env>))
      (display object)))

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output 
           (eval input 
                 the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) 
  (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))
