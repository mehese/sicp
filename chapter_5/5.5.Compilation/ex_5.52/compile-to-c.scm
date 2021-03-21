#lang sicp

(#%require racket/include)
(#%require racket/string)
(#%require (only racket/base open-output-string
                             get-output-string
                             write
                             format))

;;(#%require (only racket/string string-replace))
;; I think it's ok to use functions instead of labels
;; if the register is continue, use a function
;; if it's next, don't use a function
;; all functions will be type LispObject
;; if they modify a registry, instead of save/restore just use
;;   function variables (abuse the C stack)

;;;;;;;;
(include "scheme-syntax.scm")
(include "../machine.scm")
(include "../eceval-support.scm")
(include "c-compiler-support.scm")
(include "metacircular-scheme.scm")

;; any old value to create the variable so that
;;  compile-and-go and/or start-eceval can set! it.
(set! the-global-environment '())

;; Modification of section 4.1.4 procedure
;; **replaces version in syntax file
(set! user-print
      (lambda
          ( object)
        (cond ((compound-procedure? object)
               (display (list 'compound-procedure
                              (procedure-parameters object)
                              (procedure-body object)
                              '<procedure-env>)))
              ((compiled-procedure? object)
               (display '<compiled-procedure>))
              (else (display object)))))

;; self evaluating
'(compile 2 'val 'next)
'(code (compile 2 'val 'next)) ;; works

;; quotation
'(compile ''a 'val 'next) ;; works
'(compile ''(a b c) 'val 'next) ;; works

;; variable
'(compile 'a 'val 'next) ;; works
'(compile '(begin (define a 2) a) 'val 'next) ;; works
'(compile '(begin (define a 2) (define b 3) (+ a b)))

;; if
'(compile '(if 2 2 3) 'val 'next) ;; works
'(compile '(if 2 (if #f 2 69) 3) 'val 'next) ;; works
'(compile '(cond ((= 1 2) 'no-1)
                 ((= 2 2) 'yes-2)
                 (else 'whut))
          'val 'next) ;; works
'(compile '(cond ((= 1 1) 'yes-1)
                 ((= 2 3) 'no-2)
                 (else 'whut))
          'val 'next) ;; works
'(compile '(cond ((= 1 2) 'no-1)
                 ((= 2 3) 'no-2)
                 (else 'yes-else))
          'val 'next) ;; works

;; lambda
'(compile '(lambda (x y) 2) 'val 'next) ;; works
'(compile '(begin (lambda (x y) 2) +) 'val 'next) ;; works
'(compile '(begin (lambda (x y) 2) (lambda (a b) 3)) 'val 'next) ;; works

;; Application Primitives
'(compile '(+ 2 3) 'val 'next) ;; works
'(compile '(+ (- 1 1) 3) 'val 'next) ;; works

;; Application Compiled
'(compile '((lambda (x) 2) 5) 'val 'next) ;; works
'(compile '((lambda (x) (+ x 2)) 5) 'val 'next) ;; works
'(compile '(begin (define (a x) (+ x 2)) (a 3)) 'val 'next) ;; works
'(compile '(begin (define (equals-2 x) (if (= x 2) 1 0)) (equals-2 3)) 'val 'next) ;; works
'(compile '((lambda (x y z) (- x 1)) 5 6 7) 'val 'next) ;; works
'(compile '((lambda () 2)) 'val 'next) ;; works


;; Recursive Functions
'(compile
  '(begin
     (define (count n)
       (if (< n 1)
           n
           (count (- n 1))))
      (count 2))
  'val 'next)

'(compile
  '(begin
    (define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
    (fib 6)) 'val 'next)


(define (decorate-main-instructions instruction-list)
  "Should do the following
   - add a main function
   - add a 'return 0};' at the end of the main function"
  (define PREFIX "
int main() {

    env = environment_init();

")
  (define POSTFIX "
    print_lisp_object(val);
    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};

")
  (append (list PREFIX) instruction-list (list POSTFIX)))

(define (generate-definitions-of-labels instruction-sequence)
  (define (iter seq voids-declared)
    (cond ((null? seq)
           voids-declared)
          ((symbol? (car seq))
           (iter (cdr seq)
                 (append
                  voids-declared
                  (list (string-append "void " (symbol->string (car seq)) "(void);\n")))))
          (else (iter (cdr seq) voids-declared))))
  (apply string-append (iter instruction-sequence '())))

(define (generate-label-code aux-instructions)
  (if (null? aux-instructions)
      "\n"
      (let*
          ((label-name (car aux-instructions))
           (code-without-this-label (cdr aux-instructions))
           (code-for-this-label (main-instructions code-without-this-label))
           (rest-of-instructions  (auxiliary-instructions code-without-this-label)))
        (string-append
         "\nvoid "(symbol->string label-name) "(void) {\n"
         (apply string-append code-for-this-label)
         "};"
         (generate-label-code rest-of-instructions)))))

(define (instructions->C instruction-sequence)
  (let*
      ((START-TEXT "#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include \"scheme_objects.h\"
#include \"scheme_primitives.h\"
#include \"scheme_env.h\"
#include \"scheme_eval_apply.h\"

LispObject *expr, *proc, *val, *argl;

Environment *env;

"                                                         )
       (instruction-list (statements instruction-sequence))
       (DEFINITIONS (generate-definitions-of-labels instruction-list))
       (main-code (main-instructions instruction-list))
       (aux-instructions (auxiliary-instructions instruction-list))
       (LABEL-CODE (generate-label-code aux-instructions))
       (END-TEXT "
/* footer here */
"                                                     )
       (main-code (decorate-main-instructions main-code))
       (MAIN-CODE (apply string-append main-code)))
    (string-append START-TEXT
                   DEFINITIONS
                   MAIN-CODE
                   LABEL-CODE
                   END-TEXT)))

(define (code instruction-sequence)
  (display (instructions->C instruction-sequence)))
    

    