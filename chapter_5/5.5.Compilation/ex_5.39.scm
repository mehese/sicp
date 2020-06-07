#lang sicp

(#%require racket/include)
(include "scheme-syntax.scm")


;; Environment operators
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

(define primitive-procedures
  (list (list 'car car) (list 'cdr cdr) (list 'cons cons) (list 'null? null?)
        ;;above from book -- here are some more
        (list 'pair? pair?) (list 'cadr cadr) (list '+ +) (list '- -)
        (list '* *) (list '= =) (list '/ /) (list '> >) (list '< <)
        (list '>= >=) (list '<= <=)))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define (address-frame-index addr)
  (car addr))

(define (address-variable-index addr)
  (cadr addr))

(define (lexical-address-lookup addr env)
  ;; list-ref works like vector-ref and it saves me a lot of cdr-ing
  ;; it might be a bit cheaty, but gimme a break here
  (let*
      ((fi         (car addr)) ;; frame index
       (vi         (cadr addr)) ;; variable index
       (the-frame  (list-ref env fi))
       (the-vars   (frame-variables the-frame))
       (the-values (frame-values the-frame))
       (the-var    (list-ref the-vars vi))
       (the-value  (list-ref the-values vi)))

    (if (eq? the-value '*unassigned*)
        (error "Value is unassigned for variable" the-var)
        the-value)))

(define (list-set! val lst index)
  (if (= 0 index)
      (set-car! lst val)
      (list-set! val (cdr lst) (- index 1))))

(define (lexical-address-set! val addr env)
  (let*
      ((fi         (car addr)) ;; frame index
       (vi         (cadr addr)) ;; variable index
       (the-frame  (list-ref env fi))
       (the-vars   (frame-variables the-frame))
       (the-values (frame-values the-frame)))
    (list-set! val the-values vi)
    )
  'ok)

(define e1 (setup-environment))
(define e2 (extend-environment '(x y z) '(101 *unassigned* 103) e1))
(define ENV (extend-environment '(a b) '( 1 2) e2))

;(lexical-address-lookup '(1 1) ENV) ;; Error: Value is unassigned for variable y ✔
(lexical-address-lookup '(1 2) ENV) ;; 103, the value of z ✔
(lexical-address-lookup '(0 1) ENV) ;; 2, the value of b ✔

(lexical-address-set! 99 '(0 1) ENV)
(lexical-address-lookup '(0 1) ENV) ;; 99, the updated value of b ✔
(lexical-address-set! 8080 '(1 1) ENV)
(lexical-address-lookup '(1 1) ENV) ;; 8080, the updated value of y ✔