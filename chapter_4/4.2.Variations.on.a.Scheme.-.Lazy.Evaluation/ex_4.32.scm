#lang sicp

;; Actual problem

;; One example was already given, we can now define integral and solve without
;;  explicitly delaying any arguments

;; Old definition

;(define (integral
;         delayed-integrand initial-value dt)
;  (define int
;    (cons-stream 
;     initial-value
;     (let ((integrand 
;            (force delayed-integrand)))
;       (add-streams 
;        (scale-stream integrand dt)
;        int))))
;  int)
;
;(define (solve f y0 dt)
;  (define y (integral (delay dy) y0 dt))
;  (define dy (stream-map f y))
;  y)

;; New definition

;(define (integral integrand initial-value dt)
;  (define int
;    (cons initial-value
;          (add-lists (scale-list integrand dt) 
;                     int)))
;  int)
;
;(define (solve f y0 dt)
;  (define y (integral dy y0 dt))
;  (define dy (map f y))
;  y)


;; Ideally one would also hope we could refactor solve-2nd from ex 3.79
;;  and switch from the old definition

;(define (solve-2nd f y0 dy0 dt)
;  (define y (integral
;             (delay dy)
;             y0
;             dt))
;  (define dy (integral
;              (delay ddy)
;              dy0
;              dt))
;  (define ddy (stream-map f dy y))
;  y)

;; To this new (cleaner) definition

;(define (solve-2nd f y0 dy0 dt)
;  (define y (integral
;             dy
;             y0
;             dt))
;  (define dy (integral
;              ddy
;              dy0
;              dt))
;  (define ddy (map f dy y))
;  y)

;; However this thing with a rather cryptic error 

;Too many arguments supplied {proc items}{{thunk f #1={{{dy y . #2={f y0 dy0 dt}}
; #0={procedure #5={m} #6={{m x y}} {{#7={x y} {thunk initial-value #9={{{int .
; #4={integrand initial-value dt}} #0# {thunk ddy #1#} {thunk dy0 #1#} {thunk dt #1#}}
; . #3={{{solve-2nd solve integral integers ones add-lists scale-list map list-ref
; cdr car cons false true null? add sub = + - * / true?} {procedure #2# {{define y ;
; {integral dy y0 dt}} {define dy {integral ddy dy0 dt}} {define ddy {map f dy y}} y}
; #3#} {procedure {f y0 dt} {{define y {integral dy y0 dt}} {define dy {map f y}} y}
; #3#} {procedure #4# {{define int {cons initial-value #8={add-lists {scale-list
; integrand dt} int}}} int} #3#} {procedure #5# #6# {{#7# {thunk 1 #3#} {thunk
; {add-lists ones integers} #3#}} . #3#}} {procedure #5# #6# {{#7# {thunk 1 #3#}
; {thunk ones #3#}} . #3#}} {procedure {list1 list2} {{cond {{null? list1} list2}
; {{null? list2} list1} {else {cons {+ {car list1} {car list2}} {add-lists {cdr list1}
; {cdr list2}}}}}} #3#} {procedure {items factor} {{map {lambda {x} {* x factor}}
; items}} #3#} {procedure {proc items} {{if {null? items} {quote ()} {cons {proc {car
; items}} {map proc {cdr items}}}}} #3#} {procedure {items n} {{if {= n 0} {car items}
; {list-ref {cdr items} {- n 1}}}} #3#} {procedure {z} {{z {lambda {p q} q}}} #3#}
; {procedure {z} {{z {lambda {p q} p}}} #3#} {procedure #7# {{lambda #5# . #6#}} #3#}
; #f #t {primitive #<procedure:null?>} {primitive #<procedure:...ming/ex_4.32.scm:86:19>}
; {primitive #<procedure:...ming/ex_4.32.scm:87:19>} {primitive #<procedure:=>}
; {primitive #<procedure:+>} {primitive #<procedure:->} {primitive #<procedure:*>}
; {primitive #<procedure:/>} {primitive #<procedure:true?>}}}}} {thunk #8# #9#}}
; . #3#}} #10={procedure #5# #6# {{#7# {thunk initial-value #11={{{int . #4#} #10#
; {thunk dy #1#} {thunk y0 #1#} {thunk dt #1#}} . #3#}} {thunk #8# #11#}} . #3#}}
; {thunk {lambda {y1 y} {- {* 2 y1} y}} #3#} {thunk 1 #3#} {thunk 1 #3#} {thunk 0.0001
; #3#}} . #3#}} {thunk dy #1#} {thunk y #1#}}

;; And Google doesn't have too many responses to this problem, nor am I inclined to spend
;;  2 days trying to get to the root cause.

;; Another thing we could try is build an infinite tree, say -- left subnode is the
;; square root of the parent node, and right subnode is the square of the parent node.
;; Not really a useful structure, but works as an example

(define (true? x)
  (not (eq? x false)))

(define (false? x)
  (eq? x false))

(define primitive-procedures
  ;;
  (list ; (list 'car car)
        ; (list 'cdr cdr)
        ; (list 'cons cons)
        (list 'null? null?)
        (list 'add (lambda (x y) (+ x y)))
        (list 'sub (lambda (x y) (- x y)))
        ;; Let's get this done with
        (list '= =)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
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
             (car vals))
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

(define (procedure-body p) (caddr p))

(define (procedure-parameters p) (cadr p))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (procedure-environment p) (cadddr p))

(define (apply-l procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values 
           arguments 
           env)))  ; changed
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-delayed-args 
            arguments 
            env)   ; changed
           (procedure-environment procedure))))
        (else (error "Unknown procedure 
                      type: APPLY" 
                     procedure))))

(define (eval-lazy exp env)
  (cond ((self-evaluating? exp) 
         exp)
        ((variable? exp) 
         (lookup-variable-value exp env))
        ((quoted? exp) 
         (text-of-quotation exp))
        ((assignment? exp)
         (eval-assignment exp env))
        ((definition? exp)
         (eval-definition exp env))
        ((if? exp) 
         (eval-if exp env))
        ((lambda? exp)
         (make-procedure 
          (lambda-parameters exp)
          (lambda-body exp)
          env))
        ((let? exp)
         (eval-lazy (let->combination exp) env))
        ((begin? exp)
         (eval-sequence 
          (begin-actions exp) 
          env))
        ((cond? exp)
         (eval-lazy (cond->if exp) env))
        ((application? exp)
         (apply-l (actual-value (operator exp) env)
                  (operands exp)
                env))        
        (else
         (error "Unknown expression 
                 type: EVAL" exp))))

(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))

(define (thunk-value evaluated-thunk) 
  (cadr evaluated-thunk))

(define (force-it obj)
  (cond ((thunk? obj)
         (let ((result
                (actual-value 
                 (thunk-exp obj)
                 (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           ;; replace exp with its value:
           (set-car! (cdr obj) result) 
           ;; forget unneeded env:
           (set-cdr! (cdr obj) '()) 
           result))
        ((evaluated-thunk? obj)
         (thunk-value obj))
        (else obj)))

(define (delay-it exp env)
  (list 'thunk exp env))
(define (thunk? obj) (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

(define (actual-value exp env)
  (force-it (eval-lazy exp env)))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value 
             (first-operand exps) 
             env)
            (list-of-arg-values 
             (rest-operands exps)
             env))))

(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it 
             (first-operand exps) 
             env)
            (list-of-delayed-args 
             (rest-operands exps)
             env))))

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
      (cons (eval-lazy (first-operand exps) env)
            (list-of-values 
             (rest-operands exps) 
             env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) 
                           env))
      (eval-lazy (if-consequent exp) env)
      (eval-lazy (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) 
         (eval-lazy (first-exp exps) env))
        (else 
         (eval-lazy (first-exp exps) env)
         (eval-sequence (rest-exps exps) 
                        env))))

(define (eval-assignment exp env)
  (set-variable-value! 
   (assignment-variable exp)
   (eval-lazy (assignment-value exp) env)
   env)
  'ok)

(define (eval-definition exp env)
  (define-variable! 
    (definition-variable exp)
    (eval-lazy (definition-value exp) env)
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

(define input-prompt  ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")

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
    (let ((output (actual-value 
                   input 
                   the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) 
  (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(newline)
