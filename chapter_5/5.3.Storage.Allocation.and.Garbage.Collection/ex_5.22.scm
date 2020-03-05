#lang sicp

(#%require racket/vector)

;;; Stack machine implementation below, jump to end for implementation


(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
    (for-each (lambda (register-name)
                ((machine 'allocate-register) register-name))
              register-names)
    ((machine 'install-operations) ops)    
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))

(define (make-register name)
  (let ((contents '*unassigned*))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (set! contents value)))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (get-contents register)
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

;;**original (unmonitored) version from section 5.2.1
(define (make-stack)
  (let ((s '()))
    (define (push x)
      (set! s (cons x s)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            top)))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

;;;**monitored version from section 5.2.4
;(define (make-stack)
;  (let ((s '())
;        (number-pushes 0)
;        (max-depth 0)
;        (current-depth 0))
;    (define (push x)
;      (set! s (cons x s))
;      (set! number-pushes (+ 1 number-pushes))
;      (set! current-depth (+ 1 current-depth))
;      (set! max-depth (max current-depth max-depth)))
;    (define (pop)
;      (if (null? s)
;          (error "Empty stack -- POP")
;          (let ((top (car s)))
;            (set! s (cdr s))
;            (set! current-depth (- current-depth 1))
;            top)))    
;    (define (initialize)
;      (set! s '())
;      (set! number-pushes 0)
;      (set! max-depth 0)
;      (set! current-depth 0)
;      'done)
;    (define (print-statistics)
;      (newline)
;      (display (list 'total-pushes  '= number-pushes
;                     'maximum-depth '= max-depth)))
;    (define (dispatch message)
;      (cond ((eq? message 'push) push)
;            ((eq? message 'pop) (pop))
;            ((eq? message 'initialize) (initialize))
;            ((eq? message 'print-statistics)
;             (print-statistics))
;            (else
;             (error "Unknown request -- STACK" message))))
;    dispatch))

(define (make-vec-register size)
  (let ((v (make-vector size '*unassigned*)))
    (define (dispatch message)
      (cond
        ((eq? message 'get) v)
        (else (error "Operation not defined for memory register" message))
        ))
    dispatch))

(define (make-new-machine)
  (let* ((pc (make-register 'pc))
         (flag (make-register 'flag))
         (stack (make-stack))
         (the-instruction-sequence '())
         ;; memory implementation
         (MEMORY-SIZE 40)
         (the-cars (make-vec-register MEMORY-SIZE))
         (the-cdrs (make-vec-register MEMORY-SIZE))
         (free (lambda (message)
                   (cond
                     ((eq? message 'get)
                      (let ((res (vector-member '*unassigned* (the-cars 'get))))
                        (if (not res)
                            (error "MEMORY FULL")
                            res)))

                        
                     (else (error "Message not defined for free" message)))
                   )))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 ;(list 'print-stack-statistics
                 ;      (lambda () (stack 'print-statistics)))
                 ))
          (register-table
           (list (list 'pc pc) (list 'flag flag) (list 'free free)
                 (list 'the-cars the-cars) (list 'the-cdrs the-cdrs))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ;(display (caar insts)) (newline)
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))


(define (start machine)
  (machine 'start))

(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))

(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value)
  'done)

(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))

(define (assemble controller-text machine)
  (extract-labels controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (receive insts
                        (cons (make-label-entry next-inst
                                                insts)
                              labels))
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels)))))))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc! 
        inst
        (make-execution-procedure
         (instruction-text inst) labels machine
         pc flag stack ops)))
     insts)))

(define (make-instruction text)
  (cons text '()))

(define (instruction-text inst)
  (car inst))

(define (instruction-execution-proc inst)
  (cdr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-cdr! inst proc))

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        (cdr val)
        (error "Undefined label -- ASSEMBLE" label-name))))


(define (make-execution-procedure inst labels machine
                                  pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))


(define (make-assign inst machine labels operations pc)
  (let ((target
         (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((condition-proc
               (make-operation-exp
                condition machine labels operations)))
          (lambda ()
            (set-contents! flag (condition-proc))
            (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (test-condition test-instruction)
  (cdr test-instruction))


(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
    (if (label-exp? dest)
        (let ((insts
               (lookup-label labels (label-exp-label dest))))
          (lambda ()
            (if (get-contents flag)
                (set-contents! pc insts)
                (advance-pc pc))))
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (branch-dest branch-instruction)
  (cadr branch-instruction))


(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg
                  (get-register machine
                                (register-exp-reg dest))))
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
        (let ((action-proc
               (make-operation-exp
                action machine labels operations)))
          (lambda ()
            (action-proc)
            (advance-pc pc)))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define (perform-action inst) (cdr inst))

(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
         (let ((c (constant-exp-value exp)))
           (lambda () c)))
        ((label-exp? exp)
         (let ((insts
                (lookup-label labels
                              (label-exp-label exp))))
           (lambda () insts)))
        ((register-exp? exp)
         (let ((r (get-register machine
                                (register-exp-reg exp))))
           (lambda () (get-contents r))))
        (else
         (error "Unknown expression type -- ASSEMBLE" exp))))

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))


(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (lambda (e)
                (make-primitive-exp e machine labels))
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))

(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)
  (cdr operation-exp))


(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
    (if val
        (cadr val)
        (error "Unknown operation -- ASSEMBLE" symbol))))

;; from 4.1
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

'(REGISTER SIMULATOR LOADED)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                            ;;
;;                       FUNCTIONAL                           ;;
;;                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(define append-func
  (make-machine
   ;; Registers
   '(aux x y val continue)
   ;; Functions
   (list
    ;; Needed for cons/car/cdr implementation
    (list 'vector-ref vector-ref)
    (list 'vector-set! vector-set!)
    ;; Let's make our lives easy for this one
    (list 'cons cons)
    (list 'car car)
    (list 'cdr cdr)
    (list 'set-cdr! set-cdr!)
    (list 'set-cdr! set-cdr!)
    (list 'null? null?)
    (list 'pair? pair?)
    (list 'display display)
    )   
   ;; Code
   '(controller
     (assign continue (label all-done))

     core-loop
     (test (op null?) (reg x))
     (branch (label base-case)) ;; (if (null? x) y
     ;; Recurse
     (save continue)
     (assign continue (label after-recursion))
     (assign aux (op car) (reg x))
     (save aux) ; STACK < (car x) | continue | ...
     (assign x (op cdr) (reg x))
     (goto (label core-loop))

     after-recursion ; upon return, val is y
     (restore x) ; x is (car x)
     (restore continue); continue is whatever
     (assign val (op cons) (reg x) (reg val))
     (goto (reg continue))

     base-case
     (assign val (reg y))
     (goto (reg continue))

     all-done)))

(define example-x '(a b c (d)))
(define example-y '(1 2 3))

;; Testing it out
(begin
  (display "Append machine [FUNCTIONAL]") (newline)
  (set-register-contents! append-func 'x example-x)
  (set-register-contents! append-func 'y example-y)
  (display "Result before running machine: ")
  (display
   (get-register-contents append-func 'val)
   )
  (start append-func)
  (display "Result after running machine: ") 
  (display
   (get-register-contents append-func 'val)
   ) ;; Works for () (something); (something) (); (a b) (1 2); (a (b)) (1 2) ✔ 
  (newline) (display "Shoud be: ")(display (append example-x example-y))
  (newline)(newline)(newline))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                            ;;
;;                       IMPERATIVE                           ;;
;;                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (last-pair x)
  (if (null? (cdr x)) 
      x
      (last-pair (cdr x))))

(define (append! x y) ;; Fails for x='()
  (set-cdr! (last-pair x) y)
  x)

(define append-iter
  (make-machine
   ;; Registers
   '(aux val x y)
   ;; Functions
   (list
    ;; Needed for cons/car/cdr implementation
    (list 'vector-ref vector-ref)
    (list 'vector-set! vector-set!)
    ;; Let's make our lives easy for this one
    (list 'cons cons)
    (list 'car car)
    (list 'cdr cdr)
    (list 'set-cdr! set-cdr!)
    (list 'set-cdr! set-cdr!)
    (list 'null? null?)
    (list 'pair? pair?)
    (list 'display display)
    )   
   ;; Code
   '(controller
     (assign val (reg x)) ;; Val holds last-pair

     find-cdr
     (assign aux (op cdr) (reg val))
     (test (op null?) (reg aux))
     (branch (label found-cdr)) ;; (if (null? x) y
     (assign val (reg aux))
     (goto (label find-cdr))

     found-cdr
     (perform (op set-cdr!) (reg val) (reg y))


     all-done)))

;; Testing it out
(begin
  (display "Append machine [IMPERATIVE]") (newline)
  (set-register-contents! append-iter 'x example-x)
  (set-register-contents! append-iter 'y example-y)
  (display "Result before running machine: ")
  (display
   (get-register-contents append-iter 'x)
   )
  (start append-iter)
  (display "Result after running machine: ") 
  (display
   (get-register-contents append-iter 'x)
   ) ;; Works for (something) (); (a b) (1 2); (a (b)) (1 2) ✔ 
  ;; Can't directly compare to append! as the machine modifies x
  (newline)(newline)(newline))