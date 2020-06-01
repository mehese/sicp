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


;;;SECTION 5.5.1

(define AVAILABLE-PRIMITVES-PROCEDURES
  ;; In code, primitive to call on the guest language side
  '((= =)
    (* *)
    (- -)
    (+ +)))

(define (special-procedure? exp)
  (and (pair? exp)
       (assoc (car exp) AVAILABLE-PRIMITVES-PROCEDURES)))

(define (special-associative-procedure? exp)
  (or (tagged-list? exp '+)
      (tagged-list? exp '*)))

(define (compile exp target linkage)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp) (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage))
        ((assignment? exp)
         (compile-assignment exp target linkage))
        ((definition? exp)
         (compile-definition exp target linkage))
        ((if? exp) (compile-if exp target linkage))
        ((lambda? exp) (compile-lambda exp target linkage))
        ((begin? exp)
         (compile-sequence (begin-actions exp)
                           target
                           linkage))
        ((cond? exp) (compile (cond->if exp) target linkage))
        ;; PART 4
        ((special-associative-procedure? exp)
         (compile-special-associative-procedure exp target linkage))
        ;; PART 1, 2, 3
        ((special-procedure? exp)
         (compile-special-procedure exp target linkage))
        ((application? exp)
         (compile-application exp target linkage))
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

(define (compile-variable exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '(env) (list target)
    `((assign ,target
              (op lookup-variable-value)
              (const ,exp)
              (reg env))))))

(define (compile-assignment exp target linkage)
  (let ((var (assignment-variable exp))
        (get-value-code
         (compile (assignment-value exp) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       `((perform (op set-variable-value!)
                  (const ,var)
                  (reg val)
                  (reg env))
         (assign ,target (const ok))))))))

(define (compile-definition exp target linkage)
  (let ((var (definition-variable exp))
        (get-value-code
         (compile (definition-value exp) 'val 'next)))
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

(define (compile-if exp target linkage)
  (let ((t-branch (make-label 'true-branch))
        (f-branch (make-label 'false-branch))                    
        (after-if (make-label 'after-if)))
    (let ((consequent-linkage
           (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate exp) 'val 'next))
            (c-code
             (compile
              (if-consequent exp) target consequent-linkage))
            (a-code
             (compile (if-alternative exp) target linkage)))
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

(define (compile-sequence seq target linkage)
  (if (last-exp? seq)
      (compile (first-exp seq) target linkage)
      (preserving '(env continue)
       (compile (first-exp seq) target 'next)
       (compile-sequence (rest-exps seq) target linkage))))

;;;lambda expressions

(define (compile-lambda exp target linkage)
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
        (compile-lambda-body exp proc-entry))
       after-lambda))))

(define (compile-lambda-body exp proc-entry)
  (let ((formals (lambda-parameters exp)))
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
      `(,proc-entry
        (assign env (op compiled-procedure-env) (reg proc))
        (assign env
                (op extend-environment)
                (const ,formals)
                (reg argl)
                (reg env))))
     (compile-sequence (lambda-body exp) 'val 'return))))


;;;SECTION 5.5.3

;;;combinations

(define (compile-application exp target linkage)
  (let ((proc-code (compile (operator exp) 'proc 'next))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands exp))))
    (preserving '(env continue)
     proc-code
     (preserving '(proc continue)
      (construct-arglist operand-codes)
      (compile-procedure-call target linkage)))))

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

(define (compile-procedure-call target linkage)
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

;; PART 1
(define (list-intersection l1 l2)
  (if (null? l1)
      l1
      (if (memq (car l1) l2)
          (cons (car l1) (list-intersection (cdr l1) l2))
          (list-intersection (cdr l1) l2))))

(define (with-saved-registers affected-registers instructions)
  (if (null? affected-registers)
      instructions
      ;; If not null, wrap in save
      (let*
          ((curr-reg   (car affected-registers))
           (rest-reg   (cdr affected-registers))
           (needed     (registers-needed instructions))
           (modified   (registers-modified instructions))
           (statements (statements instructions))
           (new-insts  (append `((save ,curr-reg))
                               statements
                               `((restore ,curr-reg)))))

        (with-saved-registers
            rest-reg
          (make-instruction-sequence
           needed
           modified
           new-insts)))))

(define (protecting register-list instructions)
  "This function wraps a save/restore for each of the protected
  registers in register-list if they are modified by instructions"
  (let*
      ((reg-mod (registers-modified instructions))
       (affected-registers (list-intersection register-list reg-mod)))
    (if (null? affected-registers)
        ;; no affected registers, return as if nothing happened
        instructions
        ;; Else we need to protect them
        (with-saved-registers affected-registers instructions))))

(define a2 '(() (arg1 arg2) ((assign arg1 (const 2)) (assign arg2 (const 3)) (assign arg2 (op =) arg1 arg2))))

(define (spread-arguments argument-list)
  (let
      ((a1 (compile (car argument-list) 'arg1 'next))
       (a2 (compile (cadr argument-list) 'arg2 'next)))
    (preserving ;; Here I would want a1 wrapped in a save restore
     '(env)
     a1
     (protecting '(env arg1) a2))))

;; PART 2

(define (operator-implementation op)
  ;; Gets operator implementation in target language
  (cadr (assoc op AVAILABLE-PRIMITVES-PROCEDURES)))

(define (generate-assignment primitive-op-impl target)
  (make-instruction-sequence
   '(arg1 arg2) ;; registers needed
   `(,target)   ;; registers modified
   `((assign ,target (op ,primitive-op-impl) arg1 arg2)))) ;; statements

(define (compile-special-procedure exp target linkage)    
  (let*
      ((ze-operator (car exp))
       (op-impl (operator-implementation ze-operator))
       (assignment-instructions (generate-assignment op-impl target)) 
       (ze-operands (cdr exp)))

    (if (not (eq? linkage 'return))
        ;; Linkage is 'next, so just slap the two together
        (append-instruction-sequences
         (spread-arguments ze-operands)
         assignment-instructions)
        ;; Linkage is return, we need to save continue
        (end-with-linkage
         linkage
         (append-instruction-sequences
          (spread-arguments ze-operands)
          assignment-instructions))
        )))

;; PART 3
(define exp-to-compile
  '(define (factorial n)
     (if (= n 1)
         1
         (* (factorial (- n 1)) n)))  
)
 

(display "Resulting expression: \n")
;(compile exp-to-compile 'val 'next)
;; Result is

;((env)
; (val)
; ((assign val (op make-compiled-procedure) (label entry1) (reg env))
;  (goto (label after-lambda2))
;  entry1
;  (assign env (op compiled-procedure-env) (reg proc))
;  (assign env (op extend-environment) (const (n)) (reg argl) (reg env))
;  (assign arg1 (op lookup-variable-value) (const n) (reg env))
;  (assign arg2 (const 1))
;  (assign val (op =) arg1 arg2)
;  (test (op false?) (reg val))
;  (branch (label false-branch4))
;  true-branch3
;  (assign val (const 1))
;  (goto (reg continue))
;  false-branch4
;  (save continue)
;  (save env)
;  (assign proc (op lookup-variable-value) (const factorial) (reg env))
;  (assign arg1 (op lookup-variable-value) (const n) (reg env))
;  (assign arg2 (const 1))
;  (assign val (op -) arg1 arg2)
;  (assign argl (op list) (reg val))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch6))
;  compiled-branch7
;  (assign continue (label proc-return9))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  proc-return9
;  (assign arg1 (reg val))
;  (goto (label after-call8))
;  primitive-branch6
;  (assign arg1 (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call8
;  (restore env)
;  (assign arg2 (op lookup-variable-value) (const n) (reg env))
;  (assign val (op *) arg1 arg2)
;  (restore continue)
;  (goto (reg continue))
;  after-if5
;  after-lambda2
;  (perform (op define-variable!) (const factorial) (reg val) (reg env))
;  (assign val (const ok)))) ;; 41 instructions

;; Before the result was
;((env)
; (val) ;; Same saved registers
; ((assign val (op make-compiled-procedure) (label entry1) (reg env))
;  (goto (label after-lambda2))
;  entry1
;  (assign env (op compiled-procedure-env) (reg proc))
;  (assign env (op extend-environment) (const (n)) (reg argl) (reg env))
;  (save continue)
;  (save env)
;  (assign proc (op lookup-variable-value) (const =) (reg env))
;  (assign val (const 1))
;  (assign argl (op list) (reg val))
;  (assign val (op lookup-variable-value) (const n) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch6))
;  compiled-branch7
;  (assign continue (label after-call8))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch6
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call8
;  (restore env)
;  (restore continue)
;  (test (op false?) (reg val))
;  (branch (label false-branch4))
;  true-branch3
;  (assign val (const 1))
;  (goto (reg continue))
;  false-branch4
;  (assign proc (op lookup-variable-value) (const *) (reg env))
;  (save continue)
;  (save proc)
;  (assign val (op lookup-variable-value) (const n) (reg env))
;  (assign argl (op list) (reg val))
;  (save argl)
;  (assign proc (op lookup-variable-value) (const factorial) (reg env))
;  (save proc)
;  (assign proc (op lookup-variable-value) (const -) (reg env))
;  (assign val (const 1))
;  (assign argl (op list) (reg val))
;  (assign val (op lookup-variable-value) (const n) (reg env))
;  (assign argl (op cons) (reg val) (reg argl))
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch9))
;  compiled-branch10
;  (assign continue (label after-call11))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch9
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call11
;  (assign argl (op list) (reg val))
;  (restore proc)
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch12))
;  compiled-branch13
;  (assign continue (label after-call14))
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch12
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  after-call14
;  (restore argl)
;  (assign argl (op cons) (reg val) (reg argl))
;  (restore proc)
;  (restore continue)
;  (test (op primitive-procedure?) (reg proc))
;  (branch (label primitive-branch15))
;  compiled-branch16
;  (assign val (op compiled-procedure-entry) (reg proc))
;  (goto (reg val))
;  primitive-branch15
;  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;  (goto (reg continue))
;  after-call17
;  after-if5
;  after-lambda2
;  (perform (op define-variable!) (const factorial) (reg val) (reg env))
;  (assign val (const ok)))) ;; 78 total instructions

;; New version is much shorter.


;; PART 4

;; The thing with + and * is that they are associative so we can take
;;
;; (+ a b c d) => (+ (+ (+ a b) c) d)
;;
;; and
;;
;; (* a b c d) => (* (* (* a b) c) d)

(define (compile-special-associative-procedure exp target linkage)
  ;; If it's not the last argument
  ;;  - add compiled current code to list of instructions, target arg1
  ;; Else
  ;;  - add last code to current list of instructions, target arg2
  ;;  - end with linkage
  (define (iterate current-instructions arglist)
    (cond
      ((null? (statements current-instructions)) ;; first argument
       (iterate
        (compile (car arglist) 'arg1 'next)
        (cdr arglist)))
      ((last-exp? arglist)
       (let*
           ((v-last (car arglist))
            (code-last (compile v-last 'arg2 'next))
            (op-impl (operator-implementation (car exp)))
            (assignment-op (generate-assignment op-impl target))
            (last-instructions (preserving '(arg1) ;; If you don't preserve here
                                           code-last ;; you risk overwriting arg1
                                           assignment-op)))

         (if (not (eq? linkage 'return))
             ;; Linkage is 'next, so just slap the two together
             (append-instruction-sequences
              current-instructions
              last-instructions)
             ;; Linkage is return, we need to save continue
             (end-with-linkage
              linkage
              (append-instruction-sequences
               current-instructions
               last-instructions)))))
      (else ;; it's a middle argument, neither the first nor last
        (let*
            ;; Follow the logic you used in last preserve arg1 before the +
            ((this-argument (car arglist))
             (this-code (compile this-argument 'arg2 'next))
             (set-arguments (append-instruction-sequences
                                current-instructions
                                (protecting '(arg1 env) this-code)))
             (op-impl (operator-implementation (car exp)))
             (assignment-op (generate-assignment op-impl 'arg1))
             (new-instructions (append-instruction-sequences
                                set-arguments
                                assignment-op))) ;; accumulate results in arg1
          (iterate new-instructions (cdr arglist))))))
  (iterate (empty-instruction-sequence) (cdr exp)))

;; Results

;'(compile '(+ 2 3 4 5) 'val 'next)
;'(()
;  (arg1 arg2 val)
;  ((assign arg1 (const 2))
;   (assign arg2 (const 3))
;   (assign arg1 (op +) arg1 arg2)
;   (assign arg2 (const 4))
;   (assign arg1 (op +) arg1 arg2)
;   (assign arg2 (const 5))
;   (assign val (op +) arg1 arg2)));; ✔
;'(compile '(+ a b c d) 'val 'next)
;'((env)
;  (arg1 arg2 val)
;  ((assign arg1 (op lookup-variable-value) (const a) (reg env))
;   (assign arg2 (op lookup-variable-value) (const b) (reg env))
;   (assign arg1 (op +) arg1 arg2)
;   (assign arg2 (op lookup-variable-value) (const c) (reg env))
;   (assign arg1 (op +) arg1 arg2)
;   (assign arg2 (op lookup-variable-value) (const d) (reg env))
;   (assign val (op +) arg1 arg2)));; ✔
; (compile '(= 1 (= 2 3)) 'val 'next)
;(()
; (arg1 arg2 val)
; ((assign arg1 (const 1))
;  (save arg1)
;  (assign arg1 (const 2))
;  (assign arg2 (const 3))
;  (assign arg2 (op =) arg1 arg2)
;  (restore arg1)
;  (assign val (op =) arg1 arg2))) ;; ✔
;'(compile '(+ (+ 1 1) (+ 2 2)) 'val 'next)
;(()
; (arg1 arg2 val)
; ((assign arg1 (const 1))
;  (assign arg2 (const 1))
;  (assign arg1 (op +) arg1 arg2)
;  (save arg1)
;  (assign arg1 (const 2))
;  (assign arg2 (const 2))
;  (assign arg2 (op +) arg1 arg2)
;  (restore arg1)
;  (assign val (op +) arg1 arg2))) ;; ✔
;'(compile '(+ (+ 1 1) (+ 2 2) (+ 3 3)) 'val 'next)
;(()
; (arg1 arg2 val)
; ((assign arg1 (const 1))
;  (assign arg2 (const 1))
;  (assign arg1 (op +) arg1 arg2)
;  (save arg1)
;  (assign arg1 (const 2))
;  (assign arg2 (const 2))
;  (assign arg2 (op +) arg1 arg2)
;  (restore arg1)
;  (assign arg1 (op +) arg1 arg2)
;  (save arg1)
;  (assign arg1 (const 3))
;  (assign arg2 (const 3))
;  (assign arg2 (op +) arg1 arg2)
;  (restore arg1)
;  (assign val (op +) arg1 arg2))) ;; ✔
;'(compile '(+ 2 (+ 1 1) 2) 'val 'next)
;(()
; (arg1 arg2 val)
; ((assign arg1 (const 2))
;  (save arg1)
;  (assign arg1 (const 1))
;  (assign arg2 (const 1))
;  (assign arg2 (op +) arg1 arg2)
;  (restore arg1)
;  (assign arg1 (op +) arg1 arg2)
;  (assign arg2 (const 2))
;  (assign val (op +) arg1 arg2))) ;; ✔