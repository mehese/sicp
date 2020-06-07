#lang sicp

(#%require racket/include)
 ;;;;COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;**NOTE**This file loads the metacircular evaluator's syntax procedures
;;;;  from section 4.1.2
;;;;  You may need to change the (load ...) expression to work in your
;;;;  version of Scheme.

;;;;Then you can compile Scheme programs as shown in section 5.5.5

;;**implementation-dependent loading of syntax procedures
(include "scheme-syntax.scm")
(include "eceval-support.scm")
(include "environment-helpers.scm")

;;;SECTION 5.5.1

(define (compile exp target linkage compile-time-env)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp) (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage compile-time-env))
        ((assignment? exp)
         (compile-assignment exp target linkage compile-time-env))
        ((definition? exp)
         (compile-definition exp target linkage compile-time-env))
        ((if? exp) (compile-if exp target linkage compile-time-env))
        ((lambda? exp) (compile-lambda exp target linkage compile-time-env))
        ((begin? exp)
         (compile-sequence (begin-actions exp)
                           target
                           linkage) compile-time-env)
        ((cond? exp) (compile (cond->if exp) target linkage compile-time-env))
        ((application? exp)
         (compile-application exp target linkage compile-time-env))
        (else
         (error "Unknown expression type -- COMPILE" exp))))


(define (make-instruction-sequence needs modifies statements)
  (list needs modifies statements))

(define (empty-instruction-sequence)
  (make-instruction-sequence '() '() '()))


;;;SECTION 5.5.2

;;;linkage code

(define (compile-linkage linkage)
  (cond ((eq? linkage 'return)
         (make-instruction-sequence '(continue) '()
          '((goto (reg continue)))))
        ((eq? linkage 'next)
         (empty-instruction-sequence))
        (else
         (make-instruction-sequence '() '()
          `((goto (label ,linkage)))))))

(define (end-with-linkage linkage instruction-sequence)
  (preserving '(continue)
   instruction-sequence
   (compile-linkage linkage)))


;;;simple expressions

(define (compile-self-evaluating exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
    `((assign ,target (const ,exp))))))

(define (compile-quoted exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
    `((assign ,target (const ,(text-of-quotation exp)))))))

(define (compile-variable exp target linkage c-env) ;; CHANGED
  (let
      ((addr (find-variable exp c-env)))
    
    (if (eq? addr 'not-found)
        ;; Variable not found, business as ususal
        (end-with-linkage
         linkage
         ;; For extra brownie points we can assign val to (op the-global-env)
         ;;  and then lookup-variable-value (cons ,exp) (reg val)
         (make-instruction-sequence '(env) (list target)
                                    `((assign ,target
                                              (op lookup-variable-value)
                                              (const ,exp)
                                              (reg env)))))
      ;; Else look at exact address
      (end-with-linkage
       linkage
       (make-instruction-sequence '(env) (list target)
                                  `((assign ,target
                                            (op lexical-address-lookup)
                                            (const ,addr)
                                            (reg env))))))))

(define (compile-assignment exp target linkage c-env) ;; CHANGED
  (let*
      ((var (assignment-variable exp))
       (addr (find-variable var c-env))
       (get-value-code (compile (assignment-value exp) 'val 'next c-env)))

    (if (eq? addr 'not-found)
        ;; Business as usual
        (end-with-linkage
         linkage
         (preserving '(env)
                     get-value-code
                     (make-instruction-sequence
                      '(env val)
                      (list target)
                      `((perform (op set-variable-value!)
                                 (const ,var)
                                 (reg val)
                                 (reg env))
                        (assign ,target (const ok))))))
        ;; Else modify at exact address
        (end-with-linkage
         linkage
         (preserving '(env)
                     get-value-code
                     (make-instruction-sequence
                      '(env val)
                      (list target)
                      `((perform (op lexical-address-set!)
                                 (const ,addr)
                                 (reg val)
                                 (reg env))
                        (assign ,target (const ok))))))
    )))

(define (compile-definition exp target linkage c-env)
  (let ((var (definition-variable exp))
        (get-value-code
         (compile (definition-value exp) 'val 'next c-env)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       `((perform (op define-variable!)
                  (const ,var)
                  (reg val)
                  (reg env))
         (assign ,target (const ok))))))))


;;;conditional expressions

;;;labels (from footnote)
(define label-counter 0)

(define (new-label-number)
  (set! label-counter (+ 1 label-counter))
  label-counter)

(define (make-label name)
  (string->symbol
    (string-append (symbol->string name)
                   (number->string (new-label-number)))))
;; end of footnote

(define (compile-if exp target linkage c-env)
  (let ((t-branch (make-label 'true-branch))
        (f-branch (make-label 'false-branch))                    
        (after-if (make-label 'after-if)))
    (let ((consequent-linkage
           (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate exp) 'val 'next c-env))
            (c-code
             (compile (if-consequent exp) target consequent-linkage c-env))
            (a-code
             (compile (if-alternative exp) target linkage c-env)))
        (preserving '(env continue)
         p-code
         (append-instruction-sequences
          (make-instruction-sequence '(val) '()
           `((test (op false?) (reg val))
             (branch (label ,f-branch))))
          (parallel-instruction-sequences
           (append-instruction-sequences t-branch c-code)
           (append-instruction-sequences f-branch a-code))
          after-if))))))

;;; sequences

(define (compile-sequence seq target linkage c-env)
  (if (last-exp? seq)
      (compile (first-exp seq) target linkage c-env)
      (preserving '(env continue)
       (compile (first-exp seq) target 'next c-env)
       (compile-sequence (rest-exps seq) target linkage c-env))))

;;;lambda expressions

(define (compile-lambda exp target linkage c-env)
  (let ((proc-entry (make-label 'entry))
        (after-lambda (make-label 'after-lambda)))
    (let ((lambda-linkage
           (if (eq? linkage 'next) after-lambda linkage)))
      (append-instruction-sequences
       (tack-on-instruction-sequence
        (end-with-linkage lambda-linkage
         (make-instruction-sequence '(env) (list target)
          `((assign ,target
                    (op make-compiled-procedure)
                    (label ,proc-entry)
                    (reg env)))))
        (compile-lambda-body exp proc-entry c-env))
       after-lambda))))

;; Now modified
(define (compile-lambda-body exp proc-entry c-env)
  (let*
      ((formals (lambda-parameters exp))
        (updated-env (extend-c-env formals c-env)) ;; new
        )
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
      `(,proc-entry
        (assign env (op compiled-procedure-env) (reg proc))
        (assign env
                (op extend-environment)
                (const ,formals)
                (reg argl)
                (reg env))))
     (compile-sequence (lambda-body exp) 'val 'return updated-env)))) ;; new


;;;SECTION 5.5.3

;;;combinations

(define (compile-application exp target linkage c-env)
  (let ((proc-code (compile (operator exp) 'proc 'next c-env))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next c-env))
              (operands exp))))
    (preserving '(env continue)
     proc-code
     (preserving '(proc continue)
      (construct-arglist operand-codes)
      (compile-procedure-call target linkage c-env)))))

(define (construct-arglist operand-codes)
  (let ((operand-codes (reverse operand-codes)))
    (if (null? operand-codes)
        (make-instruction-sequence '() '(argl)
         '((assign argl (const ()))))
        (let ((code-to-get-last-arg
               (append-instruction-sequences
                (car operand-codes)
                (make-instruction-sequence '(val) '(argl)
                 '((assign argl (op list) (reg val)))))))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)
               code-to-get-last-arg
               (code-to-get-rest-args
                (cdr operand-codes))))))))

(define (code-to-get-rest-args operand-codes)
  (let ((code-for-next-arg
         (preserving '(argl)
          (car operand-codes)
          (make-instruction-sequence '(val argl) '(argl)
           '((assign argl
              (op cons) (reg val) (reg argl)))))))
    (if (null? (cdr operand-codes))
        code-for-next-arg
        (preserving '(env)
         code-for-next-arg
         (code-to-get-rest-args (cdr operand-codes))))))

;;;applying procedures

(define (compile-procedure-call target linkage c-env)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage
           (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()
        `((test (op primitive-procedure?) (reg proc))
          (branch (label ,primitive-branch))))
       (parallel-instruction-sequences
        (append-instruction-sequences
         compiled-branch
         (compile-proc-appl target compiled-linkage))
        (append-instruction-sequences
         primitive-branch
         (end-with-linkage linkage
          (make-instruction-sequence '(proc argl)
                                     (list target)
           `((assign ,target
                     (op apply-primitive-procedure)
                     (reg proc)
                     (reg argl)))))))
       after-call))))

;;;applying compiled procedures

(define (compile-proc-appl target linkage)
  (cond ((and (eq? target 'val) (not (eq? linkage 'return)))
         (make-instruction-sequence '(proc) all-regs
           `((assign continue (label ,linkage))
             (assign val (op compiled-procedure-entry)
                         (reg proc))
             (goto (reg val)))))
        ((and (not (eq? target 'val))
              (not (eq? linkage 'return)))
         (let ((proc-return (make-label 'proc-return)))
           (make-instruction-sequence '(proc) all-regs
            `((assign continue (label ,proc-return))
              (assign val (op compiled-procedure-entry)
                          (reg proc))
              (goto (reg val))
              ,proc-return
              (assign ,target (reg val))
              (goto (label ,linkage))))))
        ((and (eq? target 'val) (eq? linkage 'return))
         (make-instruction-sequence '(proc continue) all-regs
          '((assign val (op compiled-procedure-entry)
                        (reg proc))
            (goto (reg val)))))
        ((and (not (eq? target 'val)) (eq? linkage 'return))
         (error "return linkage, target not val -- COMPILE"
                target))))

;; footnote
(define all-regs '(env proc val argl continue))


;;;SECTION 5.5.4

(define (registers-needed s)
  (if (symbol? s) '() (car s)))

(define (registers-modified s)
  (if (symbol? s) '() (cadr s)))

(define (statements s)
  (if (symbol? s) (list s) (caddr s)))

(define (needs-register? seq reg)
  (memq reg (registers-needed seq)))

(define (modifies-register? seq reg)
  (memq reg (registers-modified seq)))


(define (append-instruction-sequences . seqs)
  (define (append-2-sequences seq1 seq2)
    (make-instruction-sequence
     (list-union (registers-needed seq1)
                 (list-difference (registers-needed seq2)
                                  (registers-modified seq1)))
     (list-union (registers-modified seq1)
                 (registers-modified seq2))
     (append (statements seq1) (statements seq2))))
  (define (append-seq-list seqs)
    (if (null? seqs)
        (empty-instruction-sequence)
        (append-2-sequences (car seqs)
                            (append-seq-list (cdr seqs)))))
  (append-seq-list seqs))

(define (list-union s1 s2)
  (cond ((null? s1) s2)
        ((memq (car s1) s2) (list-union (cdr s1) s2))
        (else (cons (car s1) (list-union (cdr s1) s2)))))

(define (list-difference s1 s2)
  (cond ((null? s1) '())
        ((memq (car s1) s2) (list-difference (cdr s1) s2))
        (else (cons (car s1)
                    (list-difference (cdr s1) s2)))))

(define (preserving regs seq1 seq2)
  (if (null? regs)
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
        (if (and (needs-register? seq2 first-reg)
                 (modifies-register? seq1 first-reg))
            (preserving (cdr regs)
             (make-instruction-sequence
              (list-union (list first-reg)
                          (registers-needed seq1))
              (list-difference (registers-modified seq1)
                               (list first-reg))
              (append `((save ,first-reg))
                      (statements seq1)
                      `((restore ,first-reg))))
             seq2)
            (preserving (cdr regs) seq1 seq2)))))

(define (tack-on-instruction-sequence seq body-seq)
  (make-instruction-sequence
   (registers-needed seq)
   (registers-modified seq)
   (append (statements seq) (statements body-seq))))

(define (parallel-instruction-sequences seq1 seq2)
  (make-instruction-sequence
   (list-union (registers-needed seq1)
               (registers-needed seq2))
   (list-union (registers-modified seq1)
               (registers-modified seq2))
   (append (statements seq1) (statements seq2))))

'(COMPILER LOADED)

(compile
 'a
 'val
 'next
 (extend-c-env '(a) (setup-c-env)))
;((env) (val) ((assign val (op lexical-address-lookup) (const (0 0)) (reg env))))  ✔
(compile
 'b
 'val
 'next
 (extend-c-env '(a) (setup-c-env)))
;((env) (val) ((assign val (op lookup-variable-value) (const b) (reg env))))  ✔
(compile
 '(set! a 5)
 'val
 'next
 (extend-c-env '(a) (setup-c-env)))
;((env)
; (val)
; ((assign val (const 5))
;  (perform (op lexical-address-set!) (const (0 0)) (reg val) (reg env))
;  (assign val (const ok)))) ✔
(compile
 '(set! b 5)
 'val
 'next
 (extend-c-env '(a) (setup-c-env)))
;((env)
; (val)
; ((assign val (const 5))
;  (perform (op set-variable-value!) (const b) (reg val) (reg env))
;  (assign val (const ok)))) ✔


(compile
 '((lambda (x y)
   (lambda (a b c d e)
     ((lambda (y z) (* x y z))
      (* a b x)
      (+ c d x))))
 3
 4)
 'val
 'next
 (setup-c-env))
;((env)
; (env proc argl continue val)
; ((assign proc (op make-compiled-procedure) (label entry1) (reg env))
;  (goto (label after-lambda2))
;  entry1
;  (assign env (op compiled-procedure-env) (reg proc))
;  (assign env (op extend-environment) (const (x y)) (reg argl) (reg env))
;  (assign val (op make-compiled-procedure) (label entry3) (reg env))
;  (goto (reg continue))
;  entry3
;  (assign env (op compiled-procedure-env) (reg proc))
;  (assign env (op extend-environment) (const (a b c d e)) (reg argl) (reg env))
;  (assign proc (op make-compiled-procedure) (label entry5) (reg env))
;  (goto (label after-lambda6))
;  entry5
;  (assign env (op compiled-procedure-env) (reg proc))
;  (assign env (op extend-environment) (const (y z)) (reg argl) (reg env))
;  (assign proc (op lookup-variable-value) (const *) (reg env))
;  (assign val (op lexical-address-lookup) (const (0 1)) (reg env))
;  (assign argl (op list) (reg val))
;  (assign val (op lexical-address-lookup) (const (0 0)) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (assign val (op lexical-address-lookup) (const (2 0)) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch7))
;  compiled-branch8
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch7
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  (goto (reg continue))
;  after-call9
;  after-lambda6
;  (save continue)
;  (save proc)
;  (save env)
;  (assign proc (op lookup-variable-value) (const +) (reg env))
;  (assign val (op lexical-address-lookup) (const (1 0)) (reg env))
;  (assign argl (op list) (reg val))
;  (assign val (op lexical-address-lookup) (const (0 3)) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (assign val (op lexical-address-lookup) (const (0 2)) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch13))
;  compiled-branch14
;  (assign continue (label after-call15))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch13
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call15
;  (assign argl (op list) (reg val))
;  (restore env)
;  (save argl)
;  (assign proc (op lookup-variable-value) (const *) (reg env))
;  (assign val (op lexical-address-lookup) (const (1 0)) (reg env))
;  (assign argl (op list) (reg val))
;  (assign val (op lexical-address-lookup) (const (0 1)) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (assign val (op lexical-address-lookup) (const (0 0)) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch10))
;  compiled-branch11
;  (assign continue (label after-call12))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch10
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call12
;  (restore argl)
;  (assign argl (op cons) (reg val) (reg argl))
;  (restore proc)
;  (restore continue)
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch16))
;  compiled-branch17
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch16
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  (goto (reg continue))
;  after-call18
;  after-lambda4
;  after-lambda2
;  (assign val (const 4))
;  (assign argl (op list) (reg val))
;  (assign val (const 3))
;  (assign argl (op cons) (reg val) (reg argl))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch19))
;  compiled-branch20
;  (assign continue (label after-call21))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch19
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call21)) ;; Looks like it looks up the declared variables via lexical address lookup