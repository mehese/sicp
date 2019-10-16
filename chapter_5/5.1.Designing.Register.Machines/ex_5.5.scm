#lang sicp


;; Factorial

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
  fact-done)

'(fact 4)

;; n = 4
;; continue <- fact-done
;; -> fact-loop
;; test n=1 (F)
;; STACK: [fact-done]
;; STACK: [4, fact-done]
;; n <- n-1 (= 3)
;; continue <- after-fact
;; -> fact-loop
;; test n=1 (F)
;; STACK: [after-fact, 4, fact-done]
;; STACK: [3, after-fact, 4, fact-done]
;; n <- n-1 (= 2)
;; continue <- after-fact
;; -> fact-loop
;; test n=1 (F)
;; STACK: [after-fact, 3, after-fact, 4, fact-done]
;; STACK: [2, after-fact, 3, after-fact, 4, fact-done]
;; n <- n-1 (= 1)
;; continue <- after-fact
;; -> fact-loop
;; test n=1 (T)
;; -> base case
;; val <- 1
;; -> after-fact
;; STACK: [after-fact, 3, after-fact, 4, fact-done]
;;    => n <- 2
;; STACK: [3, after-fact, 4, fact-done]
;;    => continue <- after-fact
;; val <- val * 2 (= 2)
;; -> after-fact
;; STACK: [after-fact, 4, fact-done]
;;    => n <- 3
;; STACK: [4, fact-done]
;;    => continue <- after-fact
;; val <- val * 3 (= 6)
;; -> after-fact
;; STACK: [fact-done]
;;    => n <- 4
;; STACK: []
;;    => continue <- fact-done
;; val <- val * 4 (= 24)
;; -> fact-done
;; RETURN 24 ✔

'(controller
  (assign continue (label fib-done))
  fib-loop
  (test (op <) (reg n) (const 2))
  (branch (label immediate-answer))
  ;; set up to compute Fib(n-1)
  (save continue)
  (assign continue (label afterfib-n-1))
  (save n)                           ; save old value of n
  (assign n (op -) (reg n) (const 1)); clobber n to n-1
  (goto (label fib-loop))            ; perform recursive call
  afterfib-n-1                         ; upon return, val contains Fib(n-1)
  (restore n)
  (restore continue)
  ;; set up to compute Fib(n-2)
  (assign n (op -) (reg n) (const 2))
  (save continue)
  (assign continue (label afterfib-n-2))
  (save val)                         ; save Fib(n-1)
  (goto (label fib-loop))
  afterfib-n-2                         ; upon return, val contains Fib(n-2)
  (assign n (reg val))               ; n now contains Fib(n-2)
  (restore val)                      ; val now contains Fib(n-1)
  (restore continue)
  (assign val                        ; Fib(n-1)+Fib(n-2)
          (op +) (reg val) (reg n)) 
  (goto (reg continue))              ; return to caller, answer is in val
  immediate-answer
  (assign val (reg n))               ; base case: Fib(n)=n
  (goto (reg continue))
  fib-done)

'(fib 4)

;; n <- 4
;; continue <- fib-done
;; -> fib-loop
;; test n<2 (F)
;; STACK: [fib-done]
;; continue <- afterfib-n-1
;; STACK: [4, fib-done]
;; n <- n-1 (= 3)
;; -> fib-loop
;; test n<2 (F)
;; STACK: [afterfib-n-1, 4, fib-done]
;; continue <- afterfib-n-1
;; STACK: [3, afterfib-n-1, 4, fib-done]
;; n <- n-1 (= 2)
;; -> fib-loop
;; test n<2 (F)
;; STACK: [afterfib-n-1, 3, afterfib-n-1, 4, fib-done]
;; continue <- afterfib-n-1
;; STACK: [2, afterfib-n-1, 3, afterfib-n-1, 4, fib-done]
;; n <- n-1 (= 1)
;; -> fib-loop
;; test n<2 (T)
;; -> immediate-answer
;; val <- 1
;; -> afterfib-n-1 ----- OK val=1, n=1, s(2,after-fib-1,3,after-fib1,4,fib-done)
;; STACK: [afterfib-n-1, 3, afterfib-n-1, 4, fib-done]
;;    => n <- 2
;; STACK: [3, afterfib-n-1, 4, fib-done]
;;    => continue <- afterfib-n-1
;; n <- n - 2 (= 0)
;; STACK: [afterfib-n-1, 3, afterfib-n-1, 4, fib-done]
;; continue <- afterfib-n-2
;; STACK: [1, afterfib-n-1, 3, afterfib-n-1, 4, fib-done]
;; -> fib-loop
;; test n<2 (T)
;; -> immediate-answer
;; val <- 0
;; -> afterfib-n-2
;; n <- 0
;; STACK: [afterfib-n-1, 3, afterfib-n-1, 4, fib-done]
;;    => val <- 1
;; STACK: [3, afterfib-n-1, 4, fib-done]
;;    => continue <- afterfib-n-1
;; val <- 0 + 1 (= 1)
;; -> afterfib-n-1  ----- OK val=1, c=after-fib-n-1, n=0, s(3,after-fib1,4,fib-done)
;; STACK: [afterfib-n-1, 4, fib-done]
;;    => n <- 3
;; STACK: [4, fib-done]
;;    => continue <- afterfib-n-1
;; n <- n - 2 (= 1)
;; STACK: [afterfib-n-1, 4, fib-done]
;; continue <- afterfib-n-2
;; STACK: [1, afterfib-n-1, 4, fib-done]
;; -> fib-loop
;; test n<2 (T)
;; -> immediate-answer
;; val <- 1
;; -> afterfib-n-2
;; n <- 1
;; STACK: [afterfib-n-1, 4, fib-done]
;;    => val <- 1
;; STACK: [4, fib-done]
;;    => continue <- afterfib-n-1
;; val <- 1 + 1 (= 2)
;; -> afterfib-n-1  ----- OK val=2, c=after-fib-n-1, n=1, s(4,fib-done)
;; STACK: [fib-done]
;;    => n <- 4
;; STACK: []
;;    => continue < fib-done
;; n <- n - 2 (= 2)
;; STACK: [fib-done]
;; continue <- afterfib-n-2
;; STACK: [2, fib-done]
;; -> fib-loop
;; test n<2 (F)
;; STACK: [afterfib-n-2, 2, fib-done]
;; continue <- afterfib-n-1
;; STACK: [2, afterfib-n-2, 2, fib-done]
;; n <- n - 1 (= 1)
;; -> fib-loop
;; test n< 2 (T)
;; -> immediate-answer  ----- OK val=2, c=after-fib-n-1, n=1, s(2,after-fib-n-2,2,fib-done)
;; val <- 1
;; -> afterfib-n-1
;; STACK: [afterfib-n-2, 2, fib-done]
;;    => n <- 2
;; STACK: [2, fib-done]
;;    => continue <- afterfib-n-2
;; n <- n - 2 (= 0)
;; STACK: [afterfib-n-2, 2, fib-done]
;; continue <- afterfib-n-2
;; STACK: [1, afterfib-n-2, 2, fib-done]
;; -> fib-loop  ----- OK val=1, c=after-fib-n-2, n=0, s(1,after-fib-n-2,2,fib-done)
;; test n<2 (T)
;; -> immediate-answer
;; val <- 0
;; -> afterfib-n-2
;; n <- 0
;; STACK: [afterfib-n-2, 2, fib-done]
;;    => val <- 1
;; STACK: [2, fib-done]
;;    => continue <- afterfib-n-2
;; val <- 1 + 0 (= 1)
;; -> afterfib-n-2
;; n <- 1
;; STACK: [fib-done]
;;    => val <- 2
;; STACK: []
;;    => continue <- fib-done
;; val <- 2 + 1 (= 3)
;; -> fib-done
;; RETURN 3 ✔
