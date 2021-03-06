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

;; Testing existing code

;; Fibonacci code, which is kinda the same
(define (fib n)
  (if (< n 2) 
      n 
      (+ (fib (- n 1)) (fib (- n 2)))))

;; Code rewritten a bit, so we can modify it to become the leaf
;;  counting code
(define fib-machine
  (make-machine
   ;; Registers
   '(n val continue)
   ;; Operations
   (list
    (list 'print (lambda (x) (display x) (newline)))
    (list '< <)
    (list '> >)
    (list '= =)
    (list '- -)
    (list '+ +))
   ;; Code
   '(controller
     (assign continue (label all-done))

     core-loop
     (test (op =) (reg n) (const 0))
     (branch (label base-case-0))
     (test (op >) (reg n) (const 1))
     (branch (label default-case))
     (goto (label base-case-1))

     default-case
     ;; set up to compute Fib(n - 1)
     (save continue)
     (assign continue (label afterfib-p-1))
     (save n)           ; save old value of n
     (assign n (op -) (reg n) (const 1)) ; clobber n to n-1
     (goto (label core-loop)) ; perform recursive call

     afterfib-p-1 ; upon return, val contains Fib(n - 1)
     (restore n)
     (restore continue) ;; this and the save below doesn't make much sense
     ;; set up to compute Fib(n - 2)
     (assign n (op -) (reg n) (const 2))
     (save continue) ;; what is happening here
     (assign continue (label afterfib-p-2))
     (save val)         ; save Fib(n - 1)
     (goto (label core-loop))

     afterfib-p-2 ; upon return, val contains Fib(n - 2)
     (assign n (reg val)) ; n now contains Fib(n - 2)
     (restore val)      ; val now contains Fib(n - 1)
     (restore continue)
     (assign val (op +) (reg val) (reg n)) ; Fib(n - 1) + Fib(n - 2)
     (goto (reg continue))   ;  return to caller, answer is in val

     base-case-0
     (assign val (const 0))   ; base case: Fib(n) = n
     (goto (reg continue))

     base-case-1
     (assign val (const 1))   ; base case: Fib(n) = n
     (goto (reg continue))

    all-done)))

(begin
  (display "Fib machine") (newline)
  (set-register-contents! fib-machine 'n 8)
  (display "Result before running machine: ")
  (display
   (get-register-contents fib-machine 'val)
   )
  (start fib-machine)
  (display "Result after running machine: ") 
  (display
   (get-register-contents fib-machine 'val)
   ) ;; = 21 ✔
  (newline)(newline)(newline))

;; Rewrite works fine, let's try the recursive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                            ;;
;;                      RECURSIVE                             ;;
;;                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (count-leaves-rec tree)
  (cond ((null? tree) 0)
        ((not (pair? tree)) 1)
        (else 
         (+ (count-leaves-rec (car tree))
            (count-leaves-rec (cdr tree))))))

(define count-leaves-rec-machine
  (make-machine
   ;; Registers
   '(tree aux-reg val continue)
   ;; Functions
   (list
    ;; Needed for cons/car/cdr implementation
    (list 'vector-ref vector-ref)
    (list 'vector-set! vector-set!)
    ;; Let's make our lives easy for this one
    (list 'cons cons)
    (list 'car car)
    (list 'cdr cdr)
    (list 'null? null?)
    (list 'pair? pair?)
    (list 'display display)
    (list '= =)
    (list '* *)
    (list '+ +)
    (list '< <)
    )   
   ;; Code
   '(controller
     (assign continue (label all-done))

     core-loop
     (test (op null?) (reg tree))
     (branch (label base-case-0)) ;; (cond ((null? tree) 0))
     (test (op pair?) (reg tree)) ;; (cond ((pair? tree) (+ recurse-car recurse-cdr)))
     (branch (label default-case))
     (goto (label base-case-1)) ;; (cond (not (pair? tree) 1))

     default-case
     ;; set up to compute car
     (save continue)
     (assign continue (label after-p-1))
     (save tree)           ; save old value of n
     (assign tree (op car) (reg tree)) ; clobber n to car
     (goto (label core-loop)) ; perform recursive call

     after-p-1 ; upon return, val contains CntLeaves(d)
     (restore tree)
     (restore continue) ;; this and the save below doesn't make much sense
     ;; set up to compute cdr
     (assign tree (op cdr) (reg tree))
     (save continue) ;; what is happening here
     (assign continue (label after-p-2))
     (save val)         ; save Fib(n - 1)
     (goto (label core-loop))

     after-p-2 ; upon return, val contains CntLeaves(car) + CntLeaves(cdr)
     (assign aux-reg (reg val)) ; aux-reg now contains CntLeaves(cdr)
     ;; -> we could use tree instead of aux-reg, and save us a registry
     ;;    but I think this is more readable
     (restore val)      ; val now contains CntLeaves(car)
     (restore continue)
     (assign val (op +) (reg val) (reg aux-reg)) ;car + cdr
     (goto (reg continue))   ;  return to caller, answer is in val

     base-case-0
     (assign val (const 0))   ; base case: '()
     (goto (reg continue))

     base-case-1
     (assign val (const 1))   ; base case: leaf
     (goto (reg continue))

    all-done)))

(define example-tree
  '((1 2) 5 ((3 4) 6)))

;; Testing it out
(begin
  (display "Leaf counting machine [RECURSIVE]") (newline)
  (set-register-contents! count-leaves-rec-machine 'tree example-tree)
  (display "Result before running machine: ")
  (display
   (get-register-contents count-leaves-rec-machine 'val)
   )
  (start count-leaves-rec-machine)
  (display "Result after running machine: ") 
  (display
   (get-register-contents count-leaves-rec-machine 'val)
   ) ;; = 6 ✔ (works for other cases too, '() '(1) '(1 1 1 1))
  (newline) (display "Shoud be: ")(display (count-leaves-rec example-tree))
  (newline)(newline)(newline))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                            ;;
;;                        ITERATIVE                           ;;
;;                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (count-leaves tree)
  (define (count-iter tree n)
    (cond ((null? tree) n)
          ((not (pair? tree)) (+ n 1))
          (else 
           (count-iter  (cdr tree) (count-iter (car tree) n)))))
  (count-iter tree 0))

(define count-leaves-iter-machine
  (make-machine
   ;; Registers
   '(tree aux-reg n continue)
   ;; Functions
   (list
    ;; Needed for cons/car/cdr implementation
    (list 'vector-ref vector-ref)
    (list 'vector-set! vector-set!)
    ;; Let's make our lives easy for this one
    (list 'cons cons)
    (list 'car car)
    (list 'cdr cdr)
    (list 'null? null?)
    (list 'pair? pair?)
    (list 'display display)
    (list '= =)
    (list '* *)
    (list '+ +)
    (list '< <)
    )   
   ;; Code
   '(controller
     (assign continue (label all-done))
     (assign n (const 0))

     core-loop
     (test (op null?) (reg tree))
     (branch (label base-case-0)) ;; (cond ((null? tree) n))
     (test (op pair?) (reg tree))
     (branch (label default-case)) ;; (count-iter  (cdr tree) (count-iter (car tree) n))
     (goto (label base-case-1)) ;; (cond (not (pair? tree) n+1))

     default-case
     (save continue)
     (assign aux-reg (op car) (reg tree))
     (save aux-reg) ;; Stack: < car | continue
     (assign continue (label after-recursion))
     (assign tree (op cdr) (reg tree))
     (goto (label core-loop)) ;; recurse on cdr


     after-recursion ; upon return, n contains CntLeaves(cdr)
     (restore tree) ; tree is now car
     (restore continue) ; continue is wherever we wanted to go before recursing
     ;; set up to compute car
     (goto (label core-loop))

     base-case-0
     (assign n (reg n))   ; noop, case: '()
     (goto (reg continue))

     base-case-1
     (assign n (op +) (reg n) (const 1)) ; found a leaf, incremennt
     (goto (reg continue))

    all-done)))


;; Testing it out
(begin
  (display "Leaf counting machine [ITERATIVE]") (newline)
  (set-register-contents! count-leaves-iter-machine 'tree example-tree)
  (display "Result before running machine: ")
  (display
   (get-register-contents count-leaves-iter-machine 'n)
   )
  (start count-leaves-iter-machine)
  (display "Result after running machine: ") 
  (display
   (get-register-contents count-leaves-iter-machine 'n)
   ) ;; = 6 ✔ (works for other cases too, '() '(1) '(1 1 1 1))
  (newline) (display "Shoud be: ")(display (count-leaves example-tree))
  (newline)(newline)(newline))