;;;;COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;**NOTE**This file loads the metacircular evaluator's syntax procedures
;;;;  from section 4.1.2
;;;;  You may need to change the (load ...) expression to work in your
;;;;  version of Scheme.

;;;;Then you can compile Scheme programs as shown in section 5.5.5


;;;SECTION 5.5.1

(define NUM-FUNCTIONS 0)

(define (nonce)
  (set! NUM-FUNCTIONS (+ NUM-FUNCTIONS 1))
  (number->string NUM-FUNCTIONS))

(define (make-C-name-from-symbol symbol-val)
  ;; We can't get any Scheme label to become a C function name,
  ;;  as certain characters aren't allowed by C. All this does is change
  ;;  the common bad characters, like
  
  (let*
      ((string-val (symbol->string symbol-val))
       (string-val (string-replace string-val "-" "_"))
       (string-val (string-replace string-val "?" "_interrogate"))
       (string-val (string-replace string-val "!" "_mutate"))
       (unique-string (string-append string-val (nonce))))
    unique-string))

(define (make-tmp-var)
  (string-append "tmp_" (nonce)))

(define (compile expr target linkage)
  (cond ((self-evaluating? expr)
         (compile-self-evaluating expr target linkage))
        ((quoted? expr) (compile-quoted expr target linkage))
        ((variable? expr)
         (compile-variable expr target linkage))
        ((assignment? expr)
         (compile-assignment expr target linkage))
        ((definition? expr)
         (compile-definition expr target linkage))
        ((display? expr)
         (compile-display expr target linkage))
        ((if? expr) (compile-if expr target linkage))
        ((lambda? expr) (compile-lambda expr target linkage))
        ((begin? expr)
         (compile-sequence (begin-actions expr)
                           target
                           linkage))
        ((cond? expr) (compile (cond->if expr) target linkage))
        ((let? expr) (compile (let->combination expr) target linkage)) ;; Needed for ex 5.50
        ((application? expr)
         (compile-application expr target linkage))
        (else
         (error "Unknown expression type -- COMPILE" expr))))


(define (make-instruction-sequence needs modifies statements)
  (list needs modifies statements))

(define (empty-instruction-sequence)
  (make-instruction-sequence '() '() '()))


;;;SECTION 5.5.2

;;;linkage code

(define (compile-linkage linkage)
  (cond ((eq? linkage 'return)
         (make-instruction-sequence '(continue) '()
          (list "")))
        ((eq? linkage 'next)
         (empty-instruction-sequence))
        (else
         (make-instruction-sequence '() '()
          (list (string-append
                 INDENT
                 (symbol->string linkage)
                 "();\n")))))) ;; TODO: Maybe needs an extra '}' before the newline

(define (end-with-linkage linkage instruction-sequence)
  (preserving '(continue)
   instruction-sequence
   (compile-linkage linkage)))


;;;simple expressions

(define INDENT "    ")

(define (compile-self-evaluating expr target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
    (cond
      ((boolean? expr)
        (list (string-append INDENT (symbol->string target) " = create_lisp_atom_from_string(\"" (format "~a" expr) "\");\n")))
      ((number? expr)
        (list (string-append INDENT (symbol->string target) " = create_lisp_atom_from_string(\"" (number->string expr) "\");\n")))
      (else
       (list (string-append INDENT "\"" expr "\";\n")))))))

(define (compile-quoted expr target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
    (list
     (let*
         ;; This is a hack to cast stuff inside the quotation to a string
         ;;  it won't really work if you quote quotations (like '(a '(b 'c)))
         ;;  because my parse_lisp_object_from_string does not know how to
         ;;  handle inputs like `(quote a)` or `(quote (a b))`
         ((quote-text    (text-of-quotation expr))
          (output-string (open-output-string))
          (_             (write quote-text output-string))
          (quote-string  (get-output-string output-string)))

         
     (string-append INDENT 
                    (symbol->string target)
                    " = parse_lisp_object_from_string(\""
                    quote-string
                    "\");\n"))
    ))))

(define (compile-variable expr target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '(env) (list target)
    (list
     (string-append
       INDENT
       (symbol->string target)
       " = environment_lookup(env, \""
       (symbol->string expr)
       "\");\n")))))

(define (compile-assignment expr target linkage)
  ;; TODO: This is a SET, you will need to rewrite this
  (let ((var (assignment-variable expr))
        (get-value-code
         (compile (assignment-value expr) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       (list
        (string-append
         INDENT
         "environment_add(env, \""
         (symbol->string var)
         "\", val);\n")
        ))))))

(define (compile-definition expr target linkage)
  (let ((var (definition-variable expr))
        (get-value-code
         (compile (definition-value expr) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       (list
        (string-append
         INDENT
         "environment_add(env, \""
         (symbol->string var)
         "\", val);\n")
        ))))))

(define (compile-display expr target linkage)
  (let
      ((eval-seq  (compile (cadr expr) target linkage))
       (print-seq (make-instruction-sequence '() '()
                                             (list (string-append INDENT "print_lisp_object(" (symbol->string target) ");\n")))))
    (end-with-linkage
     linkage
     (append-instruction-sequences eval-seq print-seq)
     )))
                    

;;;conditional expressions

;;;labels (from footnote)

(define (make-label name)
  (string->symbol
    (string-append (symbol->string name) (nonce))))

;; end of footnote

(define (compile-if expr target linkage)
"
save env ☑
[MAIN OF p-code] ☑
restore env ☑

if is_true(val) { ☑
[MAIN OF c-code] ☑
} else { ☑
[MAIN OF a-code] ☑
}
linkage ☑

[AUXILIARIES OF p-code]
[AUXILIARIES OF c-code]
[AUXILIARIES OF a-code]
"
  (let*
      ((p-code (compile (if-predicate expr) 'val 'next))
       (c-code (compile (if-consequent expr) 'val 'next))
       (a-code (compile (if-alternative expr) 'val 'next))
       (p-main (make-instruction-sequence (registers-needed p-code)
                                          (registers-modified p-code)
                                          (main-instructions (statements p-code))))
       (p-main-protected (preserve-one-register p-main 'env))
       (all-reg-needed   (set-union (registers-needed p-main-protected)
                                    (registers-needed a-code)
                                    (registers-needed c-code)))
       (all-reg-modified (set-union (registers-modified p-main-protected)
                                    (registers-modified a-code)
                                    (registers-modified c-code)))  
       (c-main (main-instructions (statements c-code)))
       (a-main (main-instructions (statements a-code)))
       (p-aux  (auxiliary-instructions (statements p-code)))
       (c-aux  (auxiliary-instructions (statements c-code)))
       (a-aux  (auxiliary-instructions (statements a-code)))
       )
    ;; TODO: return not just the instructions but the modified and needed
    ;;  registers
    (make-instruction-sequence
     all-reg-needed
     all-reg-modified
     (append
      (statements p-main-protected)
      (list (string-append INDENT "if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {\n"))
      ;; Indent lines of consequent
      (map (lambda (line) (string-append INDENT line)) c-main)
      (list (string-append INDENT "} else {\n"))
      (map (lambda (line) (string-append INDENT line)) a-main)
      (list (string-append INDENT "};\n"))
      (statements (compile-linkage linkage))
      p-aux
      c-aux
      a-aux
      ))

))
;  (let ((t-branch (make-label 'true_branch))
;        (f-branch (make-label 'false_branch))                    
;        (after-if (make-label 'after_if)))
;    (let ((consequent-linkage
;           (if (eq? linkage 'next) after-if linkage)))
;      (let ((p-code (compile (if-predicate expr) 'val 'next))
;            (c-code
;             (compile
;              (if-consequent expr) target consequent-linkage))
;            (a-code
;             (compile (if-alternative expr) target linkage)))
;        (preserving '(env continue)
;         p-code
;         (append-instruction-sequences
;          (make-instruction-sequence '(val) '()
;           `((test (op false?) (reg val))
;             (branch (label ,f-branch))))
;          (parallel-instruction-sequences
;           (append-instruction-sequences t-branch c-code)
;           (append-instruction-sequences f-branch a-code))
;          after-if))))))

;;; sequences

(define (compile-sequence seq target linkage)
  (if (last-exp? seq)
      (compile (first-exp seq) target linkage)
      (preserving '(env continue)
       (compile (first-exp seq) target 'next)
       (compile-sequence (rest-exps seq) target linkage))))

;;;lambda expressions

;(define (compile-lambda expr target linkage)
;  (let ((proc-entry (make-label 'entry))
;        (after-lambda (make-label 'after-lambda)))
;    (let ((lambda-linkage
;           (if (eq? linkage 'next) after-lambda linkage)))
;      (append-instruction-sequences
;       (tack-on-instruction-sequence
;        (end-with-linkage lambda-linkage
;         (make-instruction-sequence '(env) (list target)
;          `((assign ,target
;                    (op make-compiled-procedure)
;                    (label ,proc-entry)
;                    (reg env)))))
;        (compile-lambda-body expr proc-entry))
;       after-lambda))))

(define (compile-lambda expr target linkage)
  (let ((proc-entry (make-label 'entry)))
       (tack-on-instruction-sequence
        (end-with-linkage linkage
         (make-instruction-sequence '(env) (list target)
          ;;`((assign ,target (op make-compiled-procedure) (label ,proc-entry)  (reg env)))
          (list
           (string-append INDENT (symbol->string target) " = create_empty_lisp_object(COMPILED_PROCEDURE);\n")
           (string-append INDENT (symbol->string target) "->CompoundFunEnvironment = env;\n")
           (string-append INDENT (symbol->string target) "->CompiledFun = &" (symbol->string proc-entry) ";\n")
           )))
        (compile-lambda-body expr proc-entry))))

(define (compile-extend-env-with-argl names)
  (define (iterate-over-names names-left instructions)
    (if (null? names-left)
        instructions
        (iterate-over-names
         (cdr names-left)
         (append instructions
                 (list (string-append INDENT "environment_add(env, \"" (symbol->string (car names-left)) "\", argl->CarPointer);\n")
                       (string-append INDENT "argl = argl->CdrPointer;\n")
                       )))
                            
        
          ))
  (iterate-over-names names '()))

(define (compile-lambda-body expr proc-entry)
  (let ((formals (lambda-parameters expr)))
    (tack-on-instruction-sequence
     (make-instruction-sequence '() '() (list proc-entry))
     (append-instruction-sequences
      (make-instruction-sequence '(env proc argl) '(env)
                                 (append
                                  (list
                                   ;;proc-entry
                                   (string-append INDENT "env = environment_copy(proc->CompoundFunEnvironment);\n"))
                                  (compile-extend-env-with-argl formals)
                                  ))
      (compile-sequence (lambda-body expr) 'val 'return)))))


;;;SECTION 5.5.3

;;;combinations

(define (compile-application expr target linkage)
  (let ((proc-code (compile (operator expr) 'proc 'next))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands expr))))
    (preserving '(env)
     proc-code
     (preserving '(proc continue)
      (construct-arglist operand-codes)
      (compile-procedure-call target linkage)))))

(define (construct-arglist operand-codes)
  (let ((operand-codes (reverse operand-codes)))
    (if (null? operand-codes)
        (make-instruction-sequence '() '(argl)
         (list
          (string-append INDENT "argl = &LispNull;\n")))
        (let ((code-to-get-last-arg
               (append-instruction-sequences
                (car operand-codes)
                ;; Takes the role of '(assign argl (op list) (reg val))
                (make-instruction-sequence '(val) '(argl)
                 (list
                  (string-append INDENT "argl = cons(val, &LispNull);\n"))))))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)
               code-to-get-last-arg
               (code-to-get-rest-args
                (cdr operand-codes))))))))

(define (code-to-get-rest-args operand-codes)
  (let* ((code-for-next-arg
         (preserving '(argl)
          (car operand-codes)
          ;; '(assign argl (op cons) (reg val) (reg argl))
          ;; One way
          ;;    LispObject* tmp_1;
          ;;    tmp_1 = create_empty_lisp_object(PAIR);
          ;;    tmp_1->CdrPointer = argl;
          ;;    tmp_1->CarPointer = val;
          ;;    argl = tmp_1;
          (make-instruction-sequence '(val argl) '(argl)
           (list
            (string-append INDENT "argl = cons(val, argl);\n")
            )))))
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
      ;;
      ;;    if (proc->type == PRIMITIVE_PROC) {
      ;;        printf("I am primitive\n");
      ;;    } else {
      ;;        printf("I am compiled\n");
      ;;    }
      (make-instruction-sequence
       '(proc argl env) ;; needs
       '(list target env) ;; modifies
       (list ;; instructions
        (string-append INDENT "if (proc->type == PRIMITIVE_PROC) {\n") ;; primitive case
        (string-append INDENT INDENT (symbol->string target) " = apply(proc, argl);\n")
        (string-append INDENT "} else {\n") ;; compiled case
        ;;  (assign val (op compiled-procedure-entry) (reg proc)) (goto (reg val))
        (string-append INDENT INDENT "proc->CompiledFun();\n") 
        (string-append INDENT "};\n")
        ))

;      (append-instruction-sequences
;       (make-instruction-sequence '(proc) '()
;        `((test (op primitive-procedure?) (reg proc))
;          (branch (label ,primitive-branch))))
;       (parallel-instruction-sequences
;        (append-instruction-sequences
;         compiled-branch
;         (compile-proc-appl target compiled-linkage))
;        (append-instruction-sequences
;         primitive-branch
;         (end-with-linkage linkage
;          (make-instruction-sequence '(proc argl)
;                                     (list target)
;           `((assign ,target
;                     (op apply-primitive-procedure)
;                     (reg proc)
;                     (reg argl)))))))
;       after-call)
      )))

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

;; Needed for stuff

(define (instruction-labels instruction-sequence)
  (define (iter-labels labels-so-far rest-of-sequence)
    (if (null? rest-of-sequence)
        (reverse labels-so-far)
        (let
            ((current-instruction (car rest-of-sequence)))
          (if (symbol? current-instruction)
              (iter-labels (cons current-instruction labels-so-far)
                           (cdr rest-of-sequence))
              (iter-labels labels-so-far
                           (cdr rest-of-sequence))))))
  (iter-labels '() instruction-sequence))

(define (main-instructions seq)
  (define (non-symbols instructions-so-far instructions-left)
    (if (or (null? instructions-left) (symbol? (car instructions-left)))
        instructions-so-far
        (non-symbols
         (append instructions-so-far (list (car instructions-left)))
         (cdr instructions-left))))
  (non-symbols '() seq))

(define (auxiliary-instructions seq)
  (if (or (null? seq) (symbol? (car seq)))
      seq
      (auxiliary-instructions (cdr seq))))

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
     (append (main-instructions (statements seq1))
             (main-instructions (statements seq2))
             (auxiliary-instructions (statements seq1))
             (auxiliary-instructions (statements seq2)))))
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

(define (set-union . args)
  (if (null? args)
      '()
      (list-union (car args) (apply set-union (cdr args)))))

(define (list-difference s1 s2)
  (cond ((null? s1) '())
        ((memq (car s1) s2) (list-difference (cdr s1) s2))
        (else (cons (car s1)
                    (list-difference (cdr s1) s2)))))

(define (filter filter-fun lst)
  (define (iter seen left)
    (if (null? left)
        seen
        (let
            ((curr-elem (car left)))
          (if (filter-fun curr-elem)
              (iter
               (cons curr-elem seen)
               (cdr left))
              (iter
               seen
               (cdr left))))))
  (iter '() lst))

(define (preserve-one-register seq reg-name) ;; TODO: Change the append to save/restore around the main
  (if (modifies-register? seq reg-name)
      ;; We need to save and restore the register
      ;; TO DO this returns instruction lists now
      (let*
          ((tmp-var-name (make-tmp-var))
           (needed       (registers-needed seq))
           (modified     (registers-modified seq))
           (modified     (filter (lambda (reg) (not (eq? 'env reg))) modified)))
        (if (eq? reg-name 'env)
            ;; Wrap env save/restore around it
            (make-instruction-sequence
             needed
             modified
             (append
              (list
               (string-append INDENT
                              "Environment* "
                              tmp-var-name
                              ";\n"
                              INDENT
                              tmp-var-name
                              " = environment_copy(env);\n"))
              (statements seq)
              (list
               (string-append INDENT
                              "env = environment_copy("
                              tmp-var-name
                              ");\n"))))
            ;; Wrap LispObject save/restore around it
            (make-instruction-sequence
             needed
             modified
            (append
             (list
              (string-append INDENT
                             "LispObject* "
                             tmp-var-name
                             ";\n"
                             INDENT
                             tmp-var-name
                             " = "
                             (symbol->string reg-name)
                             ";\n"))
             (statements seq)
             (list
              (string-append INDENT
                             (symbol->string reg-name)
                             " = "
                             tmp-var-name
                             ";\n"))))))

      ;; Nothing to do, return original instruction sequence
      seq))

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
              (let
                  ((tmp-var-name (make-tmp-var)))
              (if (eq? first-reg 'env)
                  ;; env is got a different type
                  (append
                   (list
                    (string-append INDENT
                                   "Environment* "
                                   tmp-var-name
                                   ";\n"
                                   INDENT
                                   tmp-var-name
                                   " = environment_copy(env);\n"))
                   (main-instructions (statements seq1))
                   (list
                    (string-append INDENT
                                   "env = environment_copy("
                                   tmp-var-name
                                   ");\n"))
                   (auxiliary-instructions (statements seq1)))
                  ;; tmp value is a LispObject
                  (append
                   (list
                    (string-append INDENT "LispObject* " tmp-var-name ";\n")
                    (string-append INDENT tmp-var-name " = " (symbol->string first-reg) ";\n"))
                   (main-instructions (statements seq1))
                   (list
                    (string-append INDENT
                                   (symbol->string first-reg)
                                   " = "
                                   tmp-var-name
                                   ";\n"))
                   (auxiliary-instructions (statements seq1))))))
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
