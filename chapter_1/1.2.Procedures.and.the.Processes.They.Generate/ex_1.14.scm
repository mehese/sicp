#lang sicp

(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((< amount 0) 0) 
        ((= kinds-of-coins 0)0)
        (else 
         (+ (cc amount (- kinds-of-coins 1))
            (cc (- amount (first-denomination 
                           kinds-of-coins))
                kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(count-change 11)

;; see figure ex_1.14.png for recursive call

;; To calculate the space complexity we must determine the depth of the
;;  call stack. In the figure the max depth is 11 -- that is equal to the
;;  amount passed to the function. However if the minimum denomination would
;;  be higher, the stack depth would be smaller since we would decrement by
;;  a higher amount. So the space requirement is O(n) where n = amount/min_denom

;; The time complexity is a bit trickier. Some resources on the internet
;;  point it as O(amount^number_of_denoms. My impression is that these arguments
;;  focus on the (cc amount 1) calls for each denom. The call tree can get very
;;  little pruning, so a full binary tree might make a better upper boundary.
