#lang sicp

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
;(define (make-stack)
;  (let ((s '()))
;    (define (push x)
;      (set! s (cons x s)))
;    (define (pop)
;      (if (null? s)
;          (error "Empty stack -- POP")
;          (let ((top (car s)))
;            (set! s (cdr s))
;            top)))
;    (define (initialize)
;      (set! s '())
;      'done)
;    (define (dispatch message)
;      (cond ((eq? message 'push) push)
;            ((eq? message 'pop) (pop))
;            ((eq? message 'initialize) (initialize))
;            (else (error "Unknown request -- STACK"
;                         message))))
;    dispatch))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

;;;**monitored version from section 5.2.4
(define (make-stack)
  (let ((s '())
        (number-pushes 0)
        (max-depth 0)
        (current-depth 0))
    (define (push x)
      (set! s (cons x s))
      (set! number-pushes (+ 1 number-pushes))
      (set! current-depth (+ 1 current-depth))
      (set! max-depth (max current-depth max-depth)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            (set! current-depth (- current-depth 1))
            top)))    
    (define (initialize)
      (set! s '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done)
    (define (print-statistics)
      (newline)
      (display (list 'total-pushes  '= number-pushes
                     'maximum-depth '= max-depth)))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            ((eq? message 'print-statistics)
             (print-statistics))
            (else
             (error "Unknown request -- STACK" message))))
    dispatch))

(define (make-new-machine)
  (define (the-default-continuation-function)
    'no-continuation)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (tracer-flag #f)
        (instruction-count 0)
         ;; Variables for this problem
        (breakpoints '())
        (continuation-function the-default-continuation-function))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
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
      
      (define (add-breakpoint bp)
        (set! breakpoints (cons bp breakpoints))
        (newline)
        (display (list 'breakpoint bp 'added)))

      (define (remove-breakpoint bp)
        (define (rm-cdr elem lst)
          (cond
            ((null? (cdr lst)) '())
            ((equal? (cadr lst) elem) (set-cdr! lst (cddr lst)))
            (else (rm-cdr elem (cdr lst)))))
        (cond
          ((not (breakpoint-set bp))
           (error "Breakpoint not set" bp))
          ((equal? bp (car breakpoints))
           (set! breakpoints (cdr breakpoints)))
          (else
           (rm-cdr bp breakpoints)))
        (newline)
        (display (list 'breakpoint bp 'removed)))

      (define (breakpoint-set bp)
        (member bp breakpoints))

      
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                (let*
                    ((current-instruction (car insts))
                     (to-do-next (lambda ()
                                   ((instruction-execution-proc current-instruction))
                                   (set! instruction-count (+ 1 instruction-count))
                                   (execute))))
                  (if tracer-flag
                      (begin
                        (display (instruction-label current-instruction))
                        (display "   ")
                        (display (instruction-text current-instruction))                        
                        (newline)))
                  (if (breakpoint-set (instruction-label current-instruction))
                      (begin
                        (display (list "found breakpoint"
                                       (instruction-label current-instruction)
                                       "stopping..."))
                        (set! continuation-function to-do-next))
                  
                      (to-do-next)))))))
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
              ((eq? message 'initialize-stack) (stack 'initialize))
              ((eq? message 'stats) (stack 'print-statistics))
              ((eq? message 'instruction-cnt) instruction-count)
              ((eq? message 'reset-instruction-cnt)
               (set! instruction-count 0))
              ((eq? message 'trace-on) (set! tracer-flag #t))
              ((eq? message 'trace-off) (set! tracer-flag #f))
              ;; Stuff for this problem
              ((eq? message 'set-breakpoint)
               (lambda (label row-num)
                 (add-breakpoint (list label row-num))))
              ((eq? message 'proceed)
               (newline)
               (display "Resuming run...")
               (newline)
               (continuation-function))
              ((eq? message 'clear-breakpoints)
               (set! breakpoints '())
               'breakpoints-cleared)
              ((eq? message 'remove-breakpoint)
               (lambda (label row-num)
                 (let
                     ((breakpoint (list label row-num)))
                   (remove-breakpoint breakpoint))))
              ((eq? message 'breakpoints)
               breakpoints)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (set-breakpoint machine label n)
  ((machine 'set-breakpoint) label n))

(define (proceed-machine machine)
  (machine 'proceed))

(define (cancel-breakpoint machine label n)
  ((machine 'remove-breakpoint) label n))

(define (cancel-all-breakpoints machine)
  (machine 'clear-breakpoints))

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
  (extract-labels controller-text 'extra-arg
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts)))

(define (extract-labels text last-label receive)
  (if (null? text)
      (receive '() '())
      (extract-labels
       (cdr text)
       ;; Not a pretty way to save it, but hey
       (if (symbol? (car text))
           ;; We found a new label
           (list (car text) 1) 
           ;; same label, mark nth row
           (list (car last-label) (+ 1 (cadr last-label)))) 
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (receive insts
                        (cons (make-label-entry next-inst
                                                insts)
                              labels))
               (receive (cons (make-instruction next-inst
                                                last-label)
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

;; Changing this as it's annoying to change the second element in a list
(define (make-instruction text label)
  (list '() text label))

(define (instruction-text inst)
  (cadr inst))

(define (instruction-label inst)
  (caddr inst))

(define (instruction-execution-proc inst)
  (car inst))

(define (set-instruction-execution-proc! inst proc)
  (set-car! inst proc))

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
  (let ((target    (get-register machine (assign-reg-name inst)))
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
    ;; Destination is either a label or a register, need
    ;;  to branch accordingly
    (cond ((label-exp? dest) ;; branch if it's a label
           (let 
               ((insts (lookup-label labels (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest) ;; branch if it's a register
           (let 
               ((reg (get-register machine (register-exp-reg dest))))
             (lambda () (set-contents! pc (get-contents reg)))))
          ;; If it's neither die gracefully
          (else (error "Bad GOTO instruction -- ASSEMBLE" inst)))))

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

(define fact-machine
  (make-machine
   ;; Registers
   '(n val continue)

   ;; operations
   (list
    (list '- -)
    (list '* *)
    (list '= =))

   '(controller
     (assign continue (label fact-done))     ; set up final return address
    
     fact-loop
     (test (op =) (reg n) (const 1))
     (branch (label base-case))
     ;; Set up for the recursive call by saving n and continue.
     ;; Set up continue so that the computation will continue
     ;; at after-fact when the subroutine returns.
     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-fact))
     (goto (label fact-loop))

     after-fact
     (restore n)
     (restore continue)
     (assign val (op *) (reg n) (reg val))   ; val now contains n(n-1)!
     (goto (reg continue))                   ; return to caller

     base-case
     (assign val (const 1))                  ; base case: 1!=1
     (goto (reg continue))                   ; return to caller
     fact-done)))

(begin
  (set-register-contents! fact-machine 'n 5)
  (display "With instruction tracing") (newline)
  (display
   (get-register-contents fact-machine 'val))
  (set-breakpoint fact-machine 'base-case 1)
  (set-breakpoint fact-machine 'fact-loop 3)
  (set-breakpoint fact-machine 'after-fact 2)
  (newline)
  (start fact-machine) ;; stops at (fact-loop 3)
  (cancel-breakpoint fact-machine 'fact-loop 3)
  (proceed-machine fact-machine) ;; stops at (base-case 1)
  (proceed-machine fact-machine) ;; stops at (after-fact 2)
  (cancel-breakpoint fact-machine 'after-fact 2)
  (proceed-machine fact-machine)
  (newline)
  (display "Final result is ")
  (display
   (get-register-contents fact-machine 'val)) ; = 120  ✔
)
