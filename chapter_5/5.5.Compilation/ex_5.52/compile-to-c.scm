#lang sicp

(#%require racket/include)
(#%require racket/string)
(#%require (only racket/base open-output-string
                             get-output-string
                             write))

;;(#%require (only racket/string string-replace))
;; I think it's ok to use functions instead of labels
;; if the register is continue, use a function
;; if it's next, don't use a function
;; all functions will be type LispObject
;; if they modify a registry, instead of save/restore just use
;;   function variables (abuse the C stack)

;;;;;;;;
(include "../scheme-syntax.scm")
(include "../machine.scm")
(include "../eceval-support.scm")
;;(include "../compiler-support.scm")
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
'(show (compile 2 'val 'next)) ;; works

;; quotation
'(compile ''a 'val 'next) ;; works
'(compile ''(a b c) 'val 'next) ;; works

;; variable
'(compile 'a 'val 'next) ;; works
'(compile '(begin (define a 2) a) 'val 'next) ;; works
'(compile '(begin (define a 2) (define b 3) (+ a b)))

;; if
'(compile '(if 2 2 3))

;; preserving
'(preserving
  '(env) ;; env is a special case, as its type in `Environment`
  '((env) (val env) ("    val = environment_lookup(\"a\", env);\n"))
  '((env) (val) ("    val = environment_lookup(\"b\", env);\n")))

'(preserving
  '(val)
  '((env) (val) ("    val = environment_lookup(\"a\", env);\n"))
'((val env) (val) ("    val = environment_lookup(\"b\", env);\n")))

(define (fix-instruction-list instruction-list)
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
  (define (insert-postfix before-main after-main)
    (if (or (null? after-main) (symbol? (car after-main)))
        (append before-main
                (list POSTFIX)
                after-main)
        (insert-postfix (append before-main (list (car after-main)))
                        (cdr after-main))))
  (cons PREFIX (insert-postfix '() instruction-list)))

(define (instruction-labels instruction-sequence)
  ;; TODO: fill me
  '())

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
       (labels   (instruction-labels instruction-sequence))
       (END-TEXT "
/* footer here */
"                                                     )
       (code-contents (fix-instruction-list instruction-list))
       (MAIN-CODE (apply string-append code-contents)))
    (string-append START-TEXT
                   MAIN-CODE
                   END-TEXT)))

(define (show instruction-sequence)
  (display (instructions->C instruction-sequence)))
    

    