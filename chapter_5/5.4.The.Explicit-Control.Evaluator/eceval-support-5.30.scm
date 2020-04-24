;;;;SIMULATION OF ECEVAL MACHINE OPERATIONS --
;;;;loaded by load-eceval.scm and by load-eceval-compiler.scm

;;;;FIRST A LOT FROM 4.1.2-4.1.4

;(load "ch5-syntax.scm");               ;section 4.1.2 syntax procedures

;;;SECTION 4.1.3
;;; operations used by compiled code and eceval except as noted

(define (true? x)
  (not (eq? x false)))

;;* not used by eceval itself -- used by compiled code when that
;; is run in the eceval machine
(define (false? x)
  (eq? x false))

;;following compound-procedure operations not used by compiled code
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))
;;(end of compound procedures)


(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

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
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))


(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
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
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))


;;;SECTION 4.1.4

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (caddr proc))

(define (all lst)
  (if (null? lst)
      #t
      (and (car lst) (all (cdr lst)))))

(define (make-check-result message-if-err check-result)
  (list 'check-result message-if-err check-result))

;; Custom checks for arguments implemented below
(define (all-numbers arglist)
  (make-check-result 'not-all-arguments-are-numbers (all (map number? arglist))))

(define (only-one-argument arglist)
  (make-check-result 'did-not-pass-exactly-1-argument (= 1 (length arglist))))

(define (only-two-arguments arglist)
  (make-check-result 'did-not-pass-exactly-2-arguments (= 2 (length arglist))))

(define (not-zero-div arglist)
  (make-check-result 'division-by-zero (not (= 0 (cadr arglist)))))

(define (argument-is-pair arglist)
  (make-check-result 'argument-is-not-pair (pair? (car arglist))))

(define (has-cadr arglist)
  (make-check-result 'argument-has-no-cadr (and (pair? (car arglist))
                                                (not (null? (cdar arglist))))))

(define primitive-procedures
  ;; Now each primitive has a list of checks for the arguments
  (list (list 'car car
              (list only-one-argument argument-is-pair))
        (list 'cdr cdr
              (list only-one-argument argument-is-pair))
        (list 'cons cons 
              (list only-two-arguments))
        (list 'null? null? 
              (list only-one-argument))
        ;;above from book -- here are some more
        (list 'null? null? 
              (list only-one-argument))
        (list 'pair? pair? 
              (list only-one-argument))
        (list 'cadr cadr 
              (list only-one-argument argument-is-pair has-cadr))
        (list '+ + 
              (list all-numbers))
        (list '- - 
              (list all-numbers))
        (list '* * 
              (list all-numbers))
        (list '= = 
              (list all-numbers only-two-arguments))
        (list '/ / 
              (list all-numbers only-two-arguments not-zero-div))
        (list '> > 
              (list all-numbers only-two-arguments))
        (list '< < 
              (list all-numbers only-two-arguments))
        (list '>= >= 
              (list all-numbers only-two-arguments))
        (list '<= <= 
              (list all-numbers only-two-arguments))
        ))

(define (procedure-name primitive-procedure)
  (car primitive-procedure))

(define (primitive-procedure-names)
  (map procedure-name
       primitive-procedures))

(define (primitive-procedure-objects) ;; Changed
  ;; This time we will add the function symbol and its checker function
  (map (lambda (proc) 
         (list 'primitive 
               (procedure-name proc) 
               (cadr proc)
               (caddr proc)))
       primitive-procedures))

(define (filter-failed-checks check-lst)
  (cond 
    ((null? check-lst) '())
    ;; If the car of the list checked to true, cdr down
    ((caddr (car check-lst)) (filter-failed-checks (cdr check-lst)))
    ;; Ooops, failed check, save its error message
    (else (cons (cadr (car check-lst)) (filter-failed-checks (cdr check-lst))))))
                                                            

(define apply-in-underlying-scheme apply)

(define (apply-primitive-procedure proc args) ;; Changed
  ;;  Alternatively we could have tried using try/catch type of statements,
  ;;  but these haven't been introduced so we assume they don't exist
  (let*
    ((function-name (cadr proc))
     (checks (cadddr proc))
     (results-checks (map (lambda (check) (check args)) checks))
     (failed-checks (filter-failed-checks results-checks)))
    
    (if (not (null? failed-checks))
        ;; We return errors because at least one check failed
        (append (list 'error) 
                failed-checks
                (list 'for 'function function-name 'with 'arguments args))
        ;; Should work, so apply function and return
        (apply-in-underlying-scheme
          (primitive-implementation proc) args))))


(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;;; Simulation of new machine operations needed by
;;;  eceval machine (not used by compiled code)

;;; From section 5.4.1 footnote
(define (empty-arglist) '())
(define (adjoin-arg arg arglist)
  (append arglist (list arg)))
(define (last-operand? ops)
  (null? (cdr ops)))

;;; From section 5.4.2 footnote, for non-tail-recursive sequences
(define (no-more-exps? seq) (null? seq))

;;; From section 5.4.4 footnote
(define (get-global-environment)
  the-global-environment)
;; will do following when ready to run, not when load this file
(define the-global-environment (setup-environment))


;;; Simulation of new machine operations needed for compiled code
;;;  and eceval/compiler interface (not used by plain eceval machine)
;;; From section 5.5.2 footnote
(define (make-compiled-procedure entry env)
  (list 'compiled-procedure entry env))
(define (compiled-procedure? proc)
  (tagged-list? proc 'compiled-procedure))
(define (compiled-procedure-entry c-proc) (cadr c-proc))
(define (compiled-procedure-env c-proc) (caddr c-proc))

