#lang sicp

(#%require racket/include)
(#%require racket/string)
(#%require racket/system)
(#%require (only racket/base open-output-string
                             get-output-string
                             write
                             format))

(include "scheme-syntax.scm")
(include "../machine.scm")
(include "c-compiler-support.scm")
(include "metacircular-scheme.scm")

;; TEST CASES

;; self evaluating
'(compile 2 'val 'next)
'(code (compile 2 'val 'next)) ;; works

;; quotation
'(compile ''a 'val 'next) ;; works
'(compile ''(a b c) 'val 'next) ;; works

;; variable
'(compile 'a 'val 'next) ;; works
'(compile '(begin (define a 2) a) 'val 'next) ;; works
'(compile '(begin (define a 2) (define b 3) (display (+ a b))) 'val 'next) ;; works

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
'(compile '(< 2 3) 'val 'next) ;; works

;; Application Compiled
'(compile '((lambda (x) 2) 5) 'val 'next) ;; works
'(compile '((lambda (x) (+ x 2)) 5) 'val 'next) ;; works
'(compile '(begin (define (a x) (+ x 2)) (a 3)) 'val 'next) ;; works
'(compile '(begin (define (equals-2 x) (if (= x 2) 1 0)) (equals-2 3)) 'val 'next) ;; works
'(compile '((lambda (x y z) (- x 1)) 5 6 7) 'val 'next) ;; works
'(compile '(begin
             (display ((lambda () 2)))) 'val 'next) ;; works
'(compile '(begin
             (define n 5)
             (display ((lambda (n) (+ n 1)) 3.14)) ;; 4.14
             (display n) ;; 5
             ) 'val 'next) ;; works


;; Recursive Functions
'(compile
  '(begin
     (define (count n)
       (if (< n 1)
           n
           (count (- n 1))))
      (count 2))
  'val 'next) ;; works

'(compile
 '(begin
    (define (factorial n) (if (= n 1) 1 (* (factorial (- n 1)) n)))
    (display (factorial 5)))
 'val
 'next) ;; works (compiled + metacircular compiled)

'(begin
    (define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
    (display (fib 6))) ;; works (compiled + metacircular compiled)

;; Some pre-requisites (newlines, errors, readlines)

'(compile '(begin (display 'newline-below) (newline) (display 'newline-above)) 'val 'next)  ;; works

'(compile '(begin (display (read))) 'val 'next) ;; works

'(compile
 '(begin
    (define (echo-loop)
      (let ((input (read)))
        (display input)
        (newline))
      (echo-loop))
    (echo-loop)) 'val 'next) ;; works

'(compile
  '(begin
     (error "ELSE clause isn't 
                        last: COND->IF"
            clauses)
     (error "Unknown expression 
                 type: EVAL" exp)
     (error "Too many arguments supplied" 
            vars 
            vals)
     (error "Too few arguments supplied" 
            vars 
            vals)
     (error "Unbound variable" var)
     (error "Unknown procedure type: APPLY" procedure)
     (error "Unbound variable: SET!" var)
     ) 'val 'next) ;; works [but with ugly spaces]

'(compile '(begin ;; More complicated echo
             (define input-prompt  'input:)
             (define output-prompt 'output:)

             (define (user-print object)
               (display object))
             
             (define (prompt-for-input string)
               (newline) (newline) 
               (display string) (newline))

             (define (echo-loop)
               (prompt-for-input input-prompt)
               (let ((input (read)))
                 (let ((output input))
                   (announce-output output-prompt)
                   (user-print output)))
               (echo-loop))

             (define (announce-output string)
               (newline) (display string) (newline))

             (echo-loop)
             )
          'val 'next) ;; works

'(compile '(begin
             (display (list 1 'a 2))
             ) 'val 'next) ;; works

'(compile '(begin
             (display (list))
             ) 'val 'next) ;; works

'(compile '(begin
             (display (list 3))
             ) 'val 'next) ;; works

;;   apply [primitive]
'(begin
   (display (apply + (list 2 3)))
   ) ;; works

'(compile '(begin
             (display (apply + '(2 3)))
             ) 'val 'next) ;; works

'(compile '(begin
             (display (apply list '(a b c)))
             ) 'val 'next) ;; works

'(compile '(begin
             (display (apply list (list )))
             ) 'val 'next) ;; works

'(compile '(begin
             (display (apply list '()))
             ) 'val 'next) ;; works

'(begin
     (define p (list 1 2 3 4))
     (set-cdr! (cdr p) 'b)
     (display p))  ;; works

'(begin
   (define f #f)
   (display 'check-shows-true)
   (display (eq? f #f))
   (newline)
   (display 'check-shows-false)
   (display (eq? f #t))
   (newline));; works
   

;; Other primitives implemented: not, pair?, number?, symbol?, length
;;                               set-car!, set-cdr! [required fixes in eval)

'(begin
    (define input-prompt  'input:)
    (define output-prompt 'output:)

    (define (user-print object)
      (display object))
             
    (define (prompt-for-input string)
      (newline) (newline) 
      (display string) (newline))

    (define (echo-loop)
      (prompt-for-input input-prompt)
      (let ((input (read)))
        (let ((output input))
          (announce-output output-prompt)
          (display 'is-quoted) (display (quoted? output)) (newline)
          (display 'original-output) (display output) (newline)
          (display 'unquoted-output) (display (unquote output)) (newline)
          ))
      (echo-loop))

    (define (announce-output string)
      (newline) (display string) (newline))

    (echo-loop)) ;; works when inputting 'a or ''a or '(a b c) or ''(a b c)

;; END TEST CASES


(define (decorate-main-instructions instruction-list)
  "Should do the following
   - add a main function
   - add a 'return 0};' at the end of the main function"
  (define PREFIX "
int main() {

    env = environment_init();

")
  (define POSTFIX "
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

(define (write-code scheme-code)
  (let
      ((file-pipe (open-output-file "src/compiled.c" #:exists 'replace))
       (c-code-text (instructions->C (compile scheme-code 'val 'next))))
    (display c-code-text file-pipe)
    (close-output-port file-pipe)))

(define (compile-and-go scheme-code)
  (write-code scheme-code)
  (system "make")
  ;; Do not uncomment below for stuff that reads stdin
  ;;(system "./compiled_scheme")
  'Done
  )

(compile-and-go METACIRCULAR-CODE)
    
    

    