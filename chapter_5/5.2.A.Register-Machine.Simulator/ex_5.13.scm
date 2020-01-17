#lang sicp

;;; Stack machine implementation below, jump to end for implementation

;; Set object
(define (make-set)
  (define (is-in-set value values)
    (cond ((null? values) #f)
          ((equal? value (car values)) #t) ;; equal? checks more deeply
          (else (is-in-set value (cdr values)))))
  (let
      ((values '()))
    (define (dispatch message)
      (cond
        ((eq? message 'add)
         (lambda (value)
           (if (is-in-set value values)
               values
               (begin ;; If value is not in set, add it
                 (set! values (cons value values))
                 values))))        
        ((eq? message 'get) values)
        (else (error "Unrecognized set message" message))))
    dispatch))

;; Helper methods for set
(define (get-set-elems set) (set 'get))
(define (add-elem-to-set! elem set) ((set 'add) elem))
(define (expand-set-with-elems! elems set)
  (if (null? elems)
      'done
      (begin
        (add-elem-to-set! (car elems) set)
        (expand-set-with-elems! (cdr elems) set))))

(define (declared-registers-in-line line)
  (define (iter found-regs rest-of-line)
    (if (null? rest-of-line)
        found-regs
        (let
            ((this-elem (car rest-of-line)))
          (if (and (pair? this-elem)
                   (eq? 'reg (car this-elem)))
              ;; Found a register!
              (iter (cons (cadr this-elem) found-regs)
                    (cdr rest-of-line))
              ;; No register found :(
              (iter found-regs
                    (cdr rest-of-line))))))
  (iter '() line))

(define (find-registers-in-line line)
  (cond
    ((symbol? line) '())
    ;; we can save only the value of one register
    ((eq? (car line) 'save) (cdr line))
    ;; similarly we can restore only the value of one register
    ((eq? (car line) 'restore) (cdr line))
    ((eq? (car line) 'assign) (cons (cadr line)
                                    (declared-registers-in-line line)))
    (else (declared-registers-in-line line))))

;; This function should iterate through the entire controller text
;;  in each line it should find the referenced registers and return
;;  a set of all found registers
(define (get-registers-from-instructions controller-text)
  (let
      ((register-set (make-set)))
    ;; For each line insert the registers found on it in the register set
    (for-each
     (lambda (found-registers) 
       (expand-set-with-elems! found-registers register-set))
     (map find-registers-in-line controller-text))
    (display "Found registers: ") (display (get-set-elems register-set)) (newline)
    (get-set-elems register-set)))

(define (make-machine ops controller-text)
  (let ((machine (make-new-machine))
        (register-names (get-registers-from-instructions controller-text)))
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

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '()))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
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
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
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

;; Trying out our new code
(define first-machine
  (make-machine
   ;; No registers
   ;'(a b)
   ;; Operations
   (list
    (list 'print (lambda (x) (display x) (newline)))
    (list '+ +))
   ;; Code
   '(controller
     (save a)
     (assign a (op +) (reg a) (reg a))
     (assign b (reg a)) ;; b = 2a0
     (save b)
     (assign b (op +) (reg b) (const 1)) ;; will dump this op
     (restore a) ;; a = 2a0
     (restore b) ;; b = a0
     )))

(begin
  (set-register-contents! first-machine 'a 2)
  (display "Result before running machine: ")
  (newline)
  (display
   (list 'a (get-register-contents first-machine 'a)))
  (newline)
  (display
   (list 'b (get-register-contents first-machine 'b)))
  (newline)
  (start first-machine)
  (display "Result after running machine: ")
  (newline)
  (display
   (list 'a (get-register-contents first-machine 'a))) ; = 3  ✔
  (newline)
  (display
   (list 'b (get-register-contents first-machine 'b))) ; = 4  ✔
  (newline))

(define fib-machine
  (make-machine
   ;; Registers
   ;'(n val continue)
   ;; Operations
   (list
    (list 'print (lambda (x) (display x) (newline)))
    (list '< <)
    (list '- -)
    (list '+ +))
   ;; Code
   '(controller
     (assign continue (label fib-done))

     fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label immediate-answer))
     ;; set up to compute Fib(n - 1)
     (save continue)
     (assign continue (label afterfib-n-1))
     (save n)           ; save old value of n
     (assign n (op -) (reg n) (const 1)) ; clobber n to n-1
     (goto (label fib-loop)) ; perform recursive call

     afterfib-n-1 ; upon return, val contains Fib(n - 1)
     (restore n)
     (restore continue) ;; this and the save below doesn't make much sense
     ;; set up to compute Fib(n - 2)
     (assign n (op -) (reg n) (const 2))
     (save continue) ;; what is happening here
     (assign continue (label afterfib-n-2))
     (save val)         ; save Fib(n - 1)
     (goto (label fib-loop))

     afterfib-n-2 ; upon return, val contains Fib(n - 2)
     (assign n (reg val)) ; n now contains Fib(n - 2)
     (restore val)      ; val now contains Fib(n - 1)
     (restore continue)
     (assign val (op +) (reg val) (reg n)) ; Fib(n - 1) + Fib(n - 2)
     (goto (reg continue))   ;  return to caller, answer is in val

     immediate-answer
     (assign val (reg n))   ; base case: Fib(n) = n
     (goto (reg continue))

    fib-done)))

(begin
  (set-register-contents! fib-machine 'n 8)
  (display "Result before running machine: ")
  (display
   (get-register-contents fib-machine 'val)
   )
  (newline)
  (start fib-machine)
  (display "Result after running machine: ")
  (display
   (get-register-contents fib-machine 'val)
   ) ;; = 21 ✔
  (newline))