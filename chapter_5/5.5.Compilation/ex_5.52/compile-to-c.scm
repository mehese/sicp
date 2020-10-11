#lang sicp

(#%require racket/include)
(#%require (only racket/string string-replace))
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

(define NUM-FUNCTIONS 0)

(define (nonce)
  (set! NUM-FUNCTIONS (+ NUM-FUNCTIONS 1))
  (number->string NUM-FUNCTIONS))

(define (make-C-name-from-symbol symbol-val)
  ;; We can't get any Scheme label to become a C function name,
  ;;  as certain characters aren't allowed by C. All this does is change
  ;;  the common bad characters, like
  
  (let*
      ((string-val   (symbol->string symbol-val))
       (string-val (string-replace string-val "-" "_"))
       (string-val (string-replace string-val "?" "_interrogate"))
       (string-val (string-replace string-val "!" "_mutate"))
       (unique-string (string-append string-val (nonce))))
    unique-string))

(define (make-tmp-var)
  (string-append "tmp_" (nonce)))

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

'(compile 2 'val 'next)
'(show (compile 2 'val 'next))
'(compile ''a 'val 'next)
'(compile '(begin (define a 2) a) 'val 'next)
'(compile '(begin (define a 2) (define b 3) (+ a b)))

(define (fix-instruction-list instruction-list)
  "Should do the following
   - add a main function
   - add a 'return 0};' at the end of the main function"
  (define PREFIX "
int main() {

    env = environment_init();

")
  (define POSTFIX "
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

(define (instructions->C instruction-sequence)
  (let*
      ((START-TEXT "
header
"                                                      )
       (instruction-list (statements instruction-sequence))
       (END-TEXT "
footer
"                                                     )
       (code-contents (fix-instruction-list instruction-list))
       (MAIN-CODE (apply string-append code-contents)))
    (list
     START-TEXT
     MAIN-CODE
     END-TEXT)))

(define (show instruction-sequence)
  (display (instructions->C instruction-sequence)))
    

    