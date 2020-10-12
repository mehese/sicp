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
          (list "};\n\n")))
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
    (if (number? expr)
        (list
         (string-append INDENT (symbol->string target) " = create_lisp_atom_from_string(\"" (number->string expr) "\");\n"))
        (list
         (string-append INDENT "\"" expr "\";\n"))))))

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

(define (compile-if expr target linkage)
  (let ((t-branch (make-label 'true_branch))
        (f-branch (make-label 'false_branch))                    
        (after-if (make-label 'after_if)))
    (let ((consequent-linkage
           (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate expr) 'val 'next))
            (c-code
             (compile
              (if-consequent expr) target consequent-linkage))
            (a-code
             (compile (if-alternative expr) target linkage)))
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

(define (compile-lambda expr target linkage)
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
        (compile-lambda-body expr proc-entry))
       after-lambda))))

(define (compile-lambda-body expr proc-entry)
  (let ((formals (lambda-parameters expr)))
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
      `(,proc-entry
        (assign env (op compiled-procedure-env) (reg proc))
        (assign env
                (op extend-environment)
                (const ,formals)
                (reg argl)
                (reg env))))
     (compile-sequence (lambda-body expr) 'val 'return))))


;;;SECTION 5.5.3

;;;combinations

(define (compile-application expr target linkage)
  (let ((proc-code (compile (operator expr) 'proc 'next))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands expr))))
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
                   (statements seq1)
                   (list
                    (string-append INDENT
                                   "env = environment_copy("
                                   tmp-var-name
                                   ");\n")))
                  ;; tmp value is a LispObject
                  (append
                   (list
                    (string-append INDENT
                                   "LispObject* "
                                   tmp-var-name
                                   ";\n"
                                   INDENT
                                   tmp-var-name
                                   " = "
                                   (symbol->string first-reg)
                                   ";\n"))
                   (statements seq1)
                   (list
                    (string-append INDENT
                                   (symbol->string first-reg)
                                   " = "
                                   tmp-var-name
                                   ";\n"))))))
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
